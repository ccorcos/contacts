const { fstat } = require("fs");
const { omit, uniq } = require("lodash");

let contacts = JSON.parse(require("fs").readFileSync("contacts.json"));

const ignoreKeys = [
  "externalCollectionPath",
  "externalFilename",
  "ABPersonFlags",
  "externalHash",
  "externalModificationTag",
  "syncStatus",
];
contacts = contacts.map((contact) => omit(contact, ignoreKeys));
console.log(uniq(contacts.flatMap((o) => Object.keys(o))));

// console.log(uniq(contacts.map((obj) => obj.URLs)));
//  Creation, Modification,, URLs
const contactsOut = contacts.map((obj) => ({
  id: obj.UID,
  firstName: obj.First,
  lastName: obj.Last,
  phoneNumber: obj.Phone?.[0]?.value,
  email: obj.Email?.[0]?.value,
  address: obj.Address?.[0]?.value,
  organization: obj.Organization,
  birthday: obj.Birthday?.slice(0, "yyyy-mm-dd".length),
  urls: obj.URLs?.map((url) => url.value),
  // JobTitle,
}));

require("fs").writeFileSync("contacts-out.json", JSON.stringify(contactsOut));

// LinkID: '542F2048-B889-4814-A250-3D741E0B251D',
// Creation: '2021-11-02T22:48:50-07:00',
// Phone: [ [Object] ],
// externalUUID: '4b63597c08fbfa5d',
// Modification: '2021-11-02T22:48:50-07:00'
