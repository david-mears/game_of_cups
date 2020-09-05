require 'uri'
require 'net/http'
require 'openssl'

class WordsApi
  # Docs https://rapidapi.com/dpventures/api/wordsapi
  # https://www.wordsapi.com/docs/?ruby#random-words

  def get_word(part_of_speech: '', max_letters: '', min_letters: '')
    # rubocop:disable Layout/LineLength
    url = URI("https://wordsapiv1.p.rapidapi.com/words/?random=true&partOfSpeech=#{part_of_speech}&lettersMax=#{max_letters}&lettersMin=#{min_letters}")
    # rubocop:enable Layout/LineLength

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
