import consumer from "./consumer"
 
consumer.subscriptions.create({ channel: "GameChannel"}, {
  received(data) {
    console.log(data)
  }
})
// TODO: find out what a 'room' is and whether I should use one to distinguish
// streams of info about different games.
// https://guides.rubyonrails.org/action_cable_overview.html#subscriber

