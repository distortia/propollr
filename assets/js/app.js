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

window.copy_share_link = function(text){
    let clipboard = window.navigator.clipboard;
    clipboard.writeText(text).then(function() {
      document.querySelector('.share-link-container a').classList.add('has-text-success')
      document.getElementById('copy-share-link').innerHTML = "Link Copied!"
  })};

// Navbar toggle
document.addEventListener('DOMContentLoaded', () => {
    let burger = document.querySelector('.navbar-burger')
    let menu = document.querySelector('.navbar-menu')
    burger.addEventListener('click', () => {
      burger.classList.toggle('is-active');
      menu.classList.toggle('is-active');
    });
  });
