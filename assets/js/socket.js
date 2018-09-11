// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket, Presence} from "phoenix"

//           //
// variables //
//           //
let initial_answered_questions = document.cookie.replace(/(?:(?:^|.*;\s*)question_token\s*\=\s*([^;]*).*$)|^.*$/, "$1")
let socket = new Socket("/socket", {params: {token: window.userToken, question_token: initial_answered_questions}})
let presences = {}

if (window.location.pathname == "/sesh" || window.location.pathname.includes('/sesh/join')) {
  socket.connect()

let sesh_id = window.sesh_id
let answer_container = document.querySelector('.answers')
let question_container = document.querySelector('.questions')
let channel = socket.channel(`sesh:${sesh_id}`, {})

//               //
// Channel Calls //
//               //

channel.join()
  .receive("ok", resp => { console.log("Joined successfully" , resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

  channel.on("questions", payload => {
    let questions = payload.questions
    // Sesh Owners should not be able to vote on questions
    if (!window.user) {
      create_questions(questions)
      create_vote_events(questions)
      toggle_answered_questions(payload.answered_questions)
    }
    create_answers(questions)
  })

  channel.on("updated_question", question => {
    if (!window.user) {
      update_question(question)
    }
  })

  channel.on("new_question", question => {
    if (!window.user) {
      new_question(question)
      create_vote_event(question)
    }
    create_answer(question)
  })

  channel.on("updated_answer", answer => {
    update_answer(answer)
  })

  channel.on("remove_question", question => {
    remove_question(question)
    remove_answer(question)
  })

  channel.on("presence_state", state => {
    presences = Presence.syncState(presences, state)
    update_counters(presences)
  })

  channel.on("presence_diff", diff => {
    presences = Presence.syncDiff(presences, diff)
    update_counters(presences)
  })

//         //
// Methods //
//         //

  let create_vote_events = (questions) => {
    questions.forEach(question => {
      create_vote_event(question)
    })
  }

  let create_vote_event = (question) => {
    let [parent, button, select_list_container, select_list] = vote_area(question.id)
    let question_token = document.cookie.replace(/(?:(?:^|.*;\s*)question_token\s*\=\s*([^;]*).*$)|^.*$/, "$1")
    button.addEventListener('click', () => {
      let options = parent.querySelector('select')
      if (options.value) {
        toggle_answered_state(button, select_list_container, select_list)
        channel.push("answer", {question_id: question.id, answer: options.value, question_token: question_token})
        .receive("ok", question_token => {
          let max_age = new Date(new Date().getTime() + 2.592e+9).toGMTString() // Cookie will expire a month from now
          document.cookie = `question_token=${question_token.question_token};max-age=${max_age}`
        })
      }
    })
  }

  let vote_area = (question_id) => {
    let parent = document.getElementById(`question_id_${question_id}`)
    let button = parent.querySelector('button')
    let select_list_container = parent.querySelector('.select')
    let select_list = parent.querySelector('select')
    return [parent, button, select_list_container, select_list]
  }

  let toggle_answered_state = (button, select_list_container, select_list) => {
    button.disabled = true
    button.innerHTML = '<span class="icon"><i class="fas fa-comment-times"></i></span><span>Answered</span>'
    button.classList.toggle('is-primary')
    button.classList.toggle('is-danger')
    select_list_container.classList.toggle('is-primary')
    select_list_container.classList.toggle('is-danger')
    select_list.disabled = !select_list.disabled
  }

  let new_question = (question) => {
   question_container.innerHTML = question_template(question) + question_container.innerHTML   
  }

  let update_question = (question) => {
    let old_question = question_container.querySelector(`#question_id_${question.id}`)
    old_question.innerHTML = question_template(question)
  }

  let create_questions = (questions, answered_questions) => {
    if(question_container.childElementCount > 0) {
      question_container.innerHTML = ''
    }
    if (!window.user) {
      questions.forEach(question => {
        question_container.innerHTML += question_template(question)
      });
    }
  }

  let toggle_answered_questions = (answered_questions) => {
    if (Object.entries(answered_questions).length) {
      Object.entries(answered_questions).forEach(([question_id, value]) => {
        toggle_answered_question(question_id, value)
      })
    }
  }

  let toggle_answered_question = (question_id, value) => {
    let [parent, button, select_list_container, select_list] = vote_area(question_id)
    toggle_answered_state(button, select_list_container, select_list)
    select_list.value = value
  }

  let question_template = (question) => {
    return `
      <div class="column is-one-quarter" id="question_column_${question.id}">
        <div class="card question" id="question_id_${question.id}">
          <header class="header">
              <p class="card-header-title">
                  Question: ${question.text}
              </p>
          </header>
          <div class="card-content">
            <div class="field">
              <label class="label">Options:</label>
              <div class="control">
                <div class="select is-fullwidth is-rounded is-primary">
                  <select>
                    <option></option>
                    ${question.options.map(option =>`<option>${option}</option>`)}
                  </select>
                </div>
              </div>
            </div>
          </div>
          <div class="card-footer">
            <div class="card-footer-item">
              <button class="button is-primary is-outlined is-fullwidth">
                <span class="icon">
                  <i class="fas fa-comment-alt-plus"></i>
                </span>
                <span>Answer</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    `
  }

  let remove_question = (question) => {
    document.querySelector(`#question_column_${question.id}`).remove()
  }
  // Can this be refactored with create answers to abstract out the innerHtml setting?
  let update_answer = (answer) => {
    let old_answer_set = answer_container.querySelector(`#answer_id_${answer.question_id} ul`)
    old_answer_set.innerHTML = ''
    Object.entries(answer.answers).forEach(opt => 
      old_answer_set.innerHTML += option_template(opt)
    )
  }

  let create_answers = (questions) => {
    // Clear out the answers if they already exist so we dont get duplicates
    if (answer_container.childElementCount > 0) {
      answer_container.innerHTML = ''
    }
    questions.forEach(question => {
      create_answer(question)
    })
  }
  
  let create_answer = (question) => {
      answer_container.innerHTML = answer_template(question) + answer_container.innerHTML

      Object.entries(question.answers).forEach(opt => 
        document.querySelector(`#answer_id_${question.id} ul`).innerHTML += option_template(opt)
        )
  }
 let answer_template = (question) => {
    return `
      <div class="column is-one-quarter" id="answer_column_${question.id}">
        <div class="card answer" id="answer_id_${question.id}">
          <header class="header">
              <p class="card-header-title">
                  Question: ${question.text}
              </p>
          </header>
          <div class="card-content">
            <p class="has-text-weight-bold">Options:</p>
            <ul></ul>
          </div>
        </div>
      </div>
    `
  }
  let option_template = (opt) => {
    return `
      <li>Option ${opt[0]}: ${opt[1]} Votes</li>
    `
  }
  let remove_answer = (question) => {
    document.querySelector(`#answer_column_${question.id}`).remove()
  }
  let update_counters = (presences) => {
    Presence.list(presences, (id, {metas: [first, ...rest]}) => {
      if (window.user) {
        document.querySelector('.pollr-count').innerText = rest.length
      }
    })
  }
}
export default socket
