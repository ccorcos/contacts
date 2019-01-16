# Contacts App

Goals:
- Import contacts from everywhere into a single database.
- Create isolated importing tools, maybe play around with different programming languages and native bindings for Node.js


### Importing Mac contacts using native APIs.

```sh
rm -f ./contacts && clang -framework Foundation -framework AddressBook contacts.m -o contacts && ./contacts
```