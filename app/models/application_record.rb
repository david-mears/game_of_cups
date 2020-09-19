class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  SYMBOLS = {
    good: '♱',
    evil: '𖤐',
    arthur: '♔'
  }.freeze
end
