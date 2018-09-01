// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

//           //
// variables //
//           //

if (window.location.href.includes("/sesh")) {
  socket.connect()
}
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

//         //
// Methods //
//         //

  let create_vote_events = (questions) => {
    questions.forEach(question => {
      create_vote_event(question)
    })
  }

  let create_vote_event = (question) => {
    let parent = document.getElementById(`question_id_${question.id}`)
      let button =  parent.querySelector('button')
      let select_list_container = parent.querySelector('.select')
      let select_list = parent.querySelector('select')
      button.addEventListener('click', () => {
        let options = parent.querySelector('select')
        if (options.value) {
          button.disabled = true
          button.innerHTML = '<span class="icon"><i class="fas fa-comment-times"></i></span><span>Answered</span>'
          button.classList.toggle('is-primary')
          button.classList.toggle('is-danger')
          select_list_container.classList.toggle('is-primary')
          select_list_container.classList.toggle('is-danger')
          select_list.disabled = !select_list.disabled
          channel.push("answer", {question_id: question.id, answer: options.value})
        }
      })
  }

  let new_question = (question) => {
   question_container.innerHTML = question_template(question) + question_container.innerHTML   
  }

  let update_question = (question) => {
    let old_question = question_container.querySelector(`#question_id_${question.id}`)
    old_question.innerHTML = question_template(question)
  }

  let create_questions = (questions) => {
    if (!window.user) {
      questions.forEach(question => {
        question_container.innerHTML += question_template(question)
      });
    }
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
export default socket
