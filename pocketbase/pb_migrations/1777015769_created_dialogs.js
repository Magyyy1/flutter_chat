/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = new Collection({
    "createRule": "@request.auth.id != \"\" && (@request.body.user1 = @request.auth.id || @request.body.user2 = @request.auth.id)",
    "deleteRule": "@request.auth.id != \"\" && (user1 = @request.auth.id || user2 = @request.auth.id)",
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
        "collectionId": "_pb_users_auth_",
        "help": "",
        "hidden": false,
        "id": "relation2354152789",
        "maxSelect": 0,
        "minSelect": 0,
        "name": "user1",
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
        "id": "relation358143215",
        "maxSelect": 0,
        "minSelect": 0,
        "name": "user2",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "relation"
      },
      {
        "autogeneratePattern": "",
        "help": "",
        "hidden": false,
        "id": "text2912969627",
        "max": 0,
        "min": 0,
        "name": "last_text",
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
        "id": "date1868620719",
        "max": "",
        "min": "",
        "name": "last_message_at",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "date"
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
    "id": "pbc_698667341",
    "indexes": [],
    "listRule": "@request.auth.id != \"\" && (user1 = @request.auth.id || user2 = @request.auth.id)",
    "name": "dialogs",
    "system": false,
    "type": "base",
    "updateRule": "@request.auth.id != \"\" && (user1 = @request.auth.id || user2 = @request.auth.id)",
    "viewRule": "@request.auth.id != \"\" && (user1 = @request.auth.id || user2 = @request.auth.id)"
  });

  return app.save(collection);
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_698667341");

  return app.delete(collection);
})
