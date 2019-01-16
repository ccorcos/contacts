# Contacts App

Goals:
- Import contacts from everywhere into a single database.
- Create isolated importing tools, maybe play around with different programming languages and native bindings for Node.js.

### Importing Mac contacts using native APIs.

```sh
rm -f ./contacts && clang -framework Foundation -framework AddressBook contacts.m -o contacts && ./contacts
```

To Do:
- node.js native bindings: https://nodejs.org/api/addons.html

### Importing Gmail contacts

### Importing Facebook

### Importing Twitter

### Database Schema

- How do we merge all these schemas?
	What if we just made a simple general UI for interacting with database schema and JSON data...

### Application Ideas

- WebRTC file sharing
- WebRTC chat / email app

- Sync other data from the filesystem. 200 points of light.