// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

window.copy_share_link = function(base_url, sesh_id){
let clipboard = window.navigator.clipboard
let full_url = `${base_url}${sesh_id}`
let share_container = document.querySelector(`#share-link-container-${sesh_id} a`)
navigator.clipboard.writeText(full_url).then(
  () => {
    share_container.classList.toggle('is-success')
    share_container.querySelector(`.copy-share-link`).innerHTML = "Link Copied!"
    setTimeout(() => {
      share_container.classList.toggle('is-success')
      share_container.querySelector(`.copy-share-link`).innerHTML = "Share Link"
    }, 3000)
  }).catch(err => {
    console.log("error")
  })
}

// Navbar toggle
document.addEventListener('DOMContentLoaded', () => {
    let burger = document.querySelector('.navbar-burger')
    let menu = document.querySelector('.navbar-menu')
    burger.addEventListener('click', () => {
      burger.classList.toggle('is-active')
      menu.classList.toggle('is-active')
    })
  })

// Feedback Modal
document.addEventListener('DOMContentLoaded', function () {
  let rootEl = document.documentElement
  let feedback_modal = document.querySelector('.modal')
  let modal_button = document.querySelector('.modal-button')
  let modal_cancel = document.querySelector('.modal-cancel')

  modal_button.addEventListener('click', () => {
    rootEl.classList.add('is-clipped')
    feedback_modal.classList.add('is-active')
  })

  modal_cancel.addEventListener('click', () => { closeModal() })

  document.addEventListener('keydown', (event) => {
    var e = event || window.event
    if (e.keyCode === 27) { closeModal() }
  })

  let closeModal = () => {
    rootEl.classList.remove('is-clipped')
    feedback_modal.classList.remove('is-active')
  }
})
