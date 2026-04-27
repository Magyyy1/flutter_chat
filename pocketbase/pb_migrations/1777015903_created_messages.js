/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = new Collection({
    "createRule": "@request.auth.id != \"\" && sender = @request.auth.id && (@request.body.dialog.user1 = @request.auth.id || @request.body.dialog.user2 = @request.auth.id)",
    "deleteRule": "@request.auth.id != \"\" && sender = @request.auth.id",
    "fields": [
      {
        "autogeneratePattern": "[a-z0-9]{15}",
        "help": "",
        "hidden": false,
        "id": "text3208210256",
        "max": 15,
        "min": 15,
        "name": "id",
        "pattern": "^[a-z0-9]+$",
        "presentable": false,
        "primaryKey": true,
        "required": true,
        "system": true,
        "type": "text"
      },
      {
        "cascadeDelete": false,
        "collectionId": "pbc_698667341",
        "help": "",
        "hidden": false,
        "id": "relation1164040290",
        "maxSelect": 0,
        "minSelect": 0,
        "name": "dialog",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "relation"
      },
      {
        "cascadeDelete": false,
        "collectionId": "_pb_users_auth_",
        "help": "",
        "hidden": false,
        "id": "relation1593854671",
        "maxSelect": 0,
        "minSelect": 0,
        "name": "sender",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "relation"
      },
      {
        "autogeneratePattern": "",
        "help": "",
        "hidden": false,
        "id": "text999008199",
        "max": 0,
        "min": 0,
        "name": "text",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "help": "",
        "hidden": false,
        "id": "bool228880198",
        "name": "is_read",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "bool"
      },
      {
        "hidden": false,
        "id": "autodate2990389176",
        "name": "created",
        "onCreate": true,
        "onUpdate": false,
        "presentable": false,
        "system": false,
        "type": "autodate"
      },
      {
        "hidden": false,
        "id": "autodate3332085495",
        "name": "updated",
        "onCreate": true,
        "onUpdate": true,
        "presentable": false,
        "system": false,
        "type": "autodate"
      }
    ],
    "id": "pbc_2605467279",
    "indexes": [],
    "listRule": "@request.auth.id != \"\" && (dialog.user1 = @request.auth.id || dialog.user2 = @request.auth.id)",
    "name": "messages",
    "system": false,
    "type": "base",
    "updateRule": "@request.auth.id != \"\" && sender = @request.auth.id",
    "viewRule": "@request.auth.id != \"\" && (dialog.user1 = @request.auth.id || dialog.user2 = @request.auth.id)"
  });

  return app.save(collection);
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_2605467279");

  return app.delete(collection);
})
