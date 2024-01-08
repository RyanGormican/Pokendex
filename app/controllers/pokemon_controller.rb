class PokemonController < ApplicationController
  require 'net/http'
  require 'json'

  def nationaldex
    url = 'https://pokeapi.co/api/v2/pokemon?limit=1025&offset=0'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    @pokemon_data = JSON.parse(response)['results']
  end

  def show
    pokemon_id = params[:id]
    url = "https://pokeapi.co/api/v2/pokemon/#{pokemon_id}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    @pokemon_details = JSON.parse(response)
  end

  private

  def determine_background_color(pokemon_id)
    case pokemon_id
    when 1..151
      'light-red'
    when 152..251
      'dark-red'
    when 252..386
      'orange'
    when 387..493
      'yellow'
    when 494..649
      'light-green'
    when 650..721
      'dark-green'
    when 722..809
      'light-blue'
    when 810..905
      'dark-blue'
    when 906..1025
      'purple'
    else
      'white'
    end
  end

  helper_method :determine_background_color
end
