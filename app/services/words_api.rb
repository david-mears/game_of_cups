require 'uri'
require 'net/http'
require 'openssl'

class WordsApi
  # Docs https://rapidapi.com/dpventures/api/wordsapi
  # https://www.wordsapi.com/docs/?ruby#random-words

  def sentence(_starting_letters)
    [adjective, noun, verb, adverb].join(' ')
  end

  def verb
    get_word('verb', 5)
  end

  def noun
    get_word('noun', 5)
  end

  def adjective
    get_word('adjective', 5)
  end

  def adverb
    get_word('adverb', 7)
  end

  private

  def get_word(part_of_speech, max_letters)
    url = URI("https://wordsapiv1.p.rapidapi.com/words/?random=true&partOfSpeech=#{part_of_speech}&lettersMax=#{max_letters}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request['x-rapidapi-host'] = 'wordsapiv1.p.rapidapi.com'
    request['x-rapidapi-key'] = ENV.fetch('RAPID_API_KEY')

    response = http.request(request)
    JSON.parse(response.read_body)['word']
  end
end
