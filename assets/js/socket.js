// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

//           //
// variables //
//           //

socket.connect()
let session_id = window.session_id
let answer_container = document.querySelector('.answers')
let question_container = document.querySelector('.questions')
let channel = socket.channel(`session:${session_id}`, {})

//               //
// Channel Calls //
//               //

channel.join()
  .receive("ok", resp => { console.log("Joined successfully" , resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

  channel.on("questions", payload => {
    let questions = payload.questions
    create_questions(questions)
    create_vote_events(questions)
    create_answers(questions)
  })

  channel.on("updated_question", question => {
    update_question(question)
  })

  channel.on("new_question", question => {
    console.log("new question recieved", question)
    new_question(question)

  })

  channel.on("updated_answer", answer => {
    update_answer(answer)
  })

//         //
// Methods //
//         //

  let create_vote_events = (questions) => {
    questions.forEach(question => {
      let parent = document.getElementById(`question_id_${question.id}`)
      let button =  parent.querySelector('button').addEventListener('click', () => {
        let options = parent.querySelector('select')
        if (options.value) {
          // Add class to disable answering again
          channel.push("answer", {question_id: question.id, answer: options.value})
        }
      })
    })
  }

  let new_question = (question) => {
   question_container.innerHTML =
    `
    <div class="question" id="question_id_${question.id}">
      <p>${question.text}</p>
      <select>
        <option></option>
        ${question.options.map(option =>`<option>${option}</option>`)}
      </select>
      <button>Answer</button>
    </div>
    ` 
    + question_container.innerHTML
  }

  let update_question = (question) => {
    let old_question = question_container.querySelector(`#question_id_${question.id}`)
    old_question.innerHTML =
    `
    <div class="question" id="question_id_${question.id}">
      <p>${question.text}</p>
      <select>
        <option></option>
        ${question.options.map(option =>`<option>${option}</option>`)}
      </select>
      <button>Answer</button>
    </div>
    `
  }

  let create_questions = (questions) => {
    questions.forEach(question => {
      question_container.innerHTML +=
        `
        <div class="question" id="question_id_${question.id}">
          <p>${question.text}</p>
          <select>
            <option></option>
            ${question.options.map(option =>`<option>${option}</option>`)}
          </select>
          <button>Answer</button>
        </div>
        `
    });
  }

  // Can this be refactored with create answers to abstract out the innerHtml setting?
  let update_answer = (answer) => {
    let old_answer_set = answer_container.querySelector(`#answer_id_${answer.question_id} ul`)
    old_answer_set.innerHTML = ''
    Object.entries(answer.answers).forEach(opt => 
      old_answer_set.innerHTML += 
      `<li>Option ${opt[0]}: ${opt[1]} Votes</li>`
    )
  }

  let create_answers = (questions) => {
    questions.forEach(question => {
      create_answer(question)
    })
  }
  
  let create_answer = (question) => {
      answer_container.innerHTML =
      `
      <div class="answer" id="answer_id_${question.id}">
        <p>Question: ${question.text}</p>
        <ul></ul>
      </div>
      `
      + answer_container.innerHTML

      Object.entries(question.answers).forEach(opt => 
        document.querySelector(`#answer_id_${question.id} ul`).innerHTML += 
        `<li>Option ${opt[0]}: ${opt[1]} Votes</li>`
      )

  }

export default socket
