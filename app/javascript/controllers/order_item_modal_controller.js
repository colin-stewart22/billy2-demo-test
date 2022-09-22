import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="order-item-modal"
export default class extends Controller {
  connect() {

    const modalSplit = document.getElementById("modal-split");

    const buttonToSplit = document.getElementById("button-to-split");

    const buttonToSplit2 = document.getElementById("button-to-split2")

    const modalPayAll = document.getElementById("modal-pay-all");

    const buttonToPayAll = document.getElementById("button-to-pay-all");

    const modalCardRoulette = document.getElementById("modal-card-roulette")

    const buttonToCardRoulette = document.getElementById("button-to-card-roulette");

    const buttonToSelectCard = document.getElementById("button-to-select-card");

    function handleToPayAllClick() {
      modalSplit.classList.add("hidden")
      modalCardRoulette.classList.add("hidden")
      modalPayAll.classList.remove("hidden")
    }

    function handleToSplitClick(){
      modalPayAll.classList.add("hidden")
      modalCardRoulette.classList.add("hidden")
      modalSplit.classList.remove("hidden")
    }

    function handleToCardRouletteClick(){
      modalPayAll.classList.add("hidden")
      modalSplit.classList.add("hidden")
      modalCardRoulette.classList.remove("hidden")
    }

    buttonToPayAll.addEventListener("click", handleToPayAllClick);
    buttonToSplit.addEventListener("click", handleToSplitClick);
    buttonToSplit2.addEventListener("click", handleToSplitClick);
    buttonToCardRoulette.addEventListener("click", handleToCardRouletteClick)
    buttonToSelectCard.addEventListener("click", randomSelect)


    function randomSelect() {
      const times = 30;

      const interval = setInterval(() => {
        const randomTag = pickRandomTag();

        highlightTag(randomTag);

        // remove the highlight after a while
        setTimeout(() => {
          unhighlightTag(randomTag);
        }, 100);
      }, 100);

      // allow times * 100 ms for the tags to randomly "highlight" themselves
      // then pick another tag
      setTimeout(() => {
        clearInterval(interval);

        setTimeout(() => {
          const randomTag = pickRandomTag();

          highlightTag(randomTag)
        }, 100);
      }, times * 100);

      setTimeout(() => {
        buttonClick();
      }, 4500)

    }

    function buttonClick() {
      const cardSelected = document.getElementsByClassName("highlight")[0];
      cardSelected.click()
      console.log(cardSelected)
    }

    function pickRandomTag() {
      const tags = document.querySelectorAll('.tag');
      return tags[Math.floor(Math.random() * tags.length)];
    }

    function highlightTag(tag) {
      tag.classList.add('highlight');
    }

    function unhighlightTag(tag) {
      tag.classList.remove('highlight');
    }
  }
}
