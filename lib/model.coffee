##////////// Shared code (client and server) //////////

Messages = new Meteor.Collection 'messages'
StreamMessages = new Meteor.Collection 'streamMessages'

Users = new Meteor.Collection 'users'

Streams = new Meteor.Collection 'streams'