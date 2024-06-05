import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "result", "link"];

  connect(){
    console.log(this.inputTarget)

  }

  searching(){
    console.log(this.inputTarget.value)
    const searchParams = new URLSearchParams(this.inputTarget.value)
    const options = {
      method: 'GET',
      headers: {
        accept: 'application/json',
        Authorization: 'Bearer TMBD_KEY'
      }
    }
    fetch(`https://api.themoviedb.org/3/search/movie?query=${searchParams}&language=fr`, options)
      .then(response => response.json())
      .then((data) => {
        this.resultTarget.innerHTML = ""
        data.results.forEach(movie => {
          if (data.results.indexOf(movie) < 4) {
          this.resultTarget.innerHTML += `<div class="autocomplete-result-item">
                                            <img class="autocomplete-result-thumbnail" src="https://image.tmdb.org/t/p/original/${movie.poster_path}" alt="${movie.title}" width="53" height="68">
                                            <a class="autocomplete-result-title" data-action="click->search#auto" data-search-target="link">${movie.title}</a>
                                            <span class="autocomplete-result-text">${movie.original_title}</span>`
          }
        });
      })

  }

  auto(event){
    this.inputTarget.value = event.currentTarget.innerText
  }
}
