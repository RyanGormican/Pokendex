class PokemonController < ApplicationController
  require 'net/http'
  require 'json'

  def nationaldex
    url = 'https://pokeapi.co/api/v2/pokemon?limit=1025&offset=0'
    @pokemon_data = fetch_data(url)['results']
  end

  def show
    pokemon_id = params[:id]
    url = "https://pokeapi.co/api/v2/pokemon/#{pokemon_id}"
    @pokemon_details = fetch_data(url)
    @abilities = fetch_abilities(@pokemon_details['abilities'])
    @varieties = fetch_varieties(@pokemon_details['species']['url'])
  end

  def types
    url = 'https://pokeapi.co/api/v2/type/'
    @pokemon_types = fetch_data(url)['results'].first(18)
  end

  def pokemon_by_type
    type_name = params[:type_name]
    url = "https://pokeapi.co/api/v2/type/#{type_name}"
    @pokemon_by_type = fetch_data(url)['pokemon']
  end

  private

  def fetch_data(url)
    uri = URI(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end
  
  def fetch_flavor_text(ability_url)
    ability_data = fetch_data(ability_url)
    flavor_text_entry = ability_data['flavor_text_entries'].find { |entry| entry['language']['name'] == 'en' }
    flavor_text_entry['flavor_text'] if flavor_text_entry
  end

  def fetch_abilities(abilities)
    abilities.map do |ability_data|
      ability_url = ability_data['ability']['url']
      flavor_text = fetch_flavor_text(ability_url)
      {
        'name' => ability_data['ability']['name'],
        'is_hidden' => ability_data['is_hidden'],
        'flavor_text' => flavor_text
      }
    end
  end

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
def fetch_varieties(species_url)
  species_data = fetch_data(species_url)
  varieties = species_data['varieties'].reject { |variety| variety['is_default'] }
  
  varieties_details = varieties.map do |variety|
    variety_data = fetch_data(variety['pokemon']['url'])
    abilities = fetch_abilities(variety_data['abilities'])
        puts "Variety: #{variety_data['name']}, Abilities: #{abilities.inspect}"
    
    {
      'name' => variety_data['name'],
      'url' => pokemon_show_path(id: variety_data['id']),
      'abilities' => abilities
    }
  end

  varieties_details
end



  helper_method :determine_background_color, :fetch_flavor_text, :fetch_data
end
