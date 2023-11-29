// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Process = require("process");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Caml_array = require("rescript/lib/js/caml_array.js");
var GildedRose = require("./GildedRose.bs.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");
var Caml_format = require("rescript/lib/js/caml_format.js");

console.log("OMGHAI!");

var items = {
  contents: [
      GildedRose.Item.make("+5 Dexterity Vest", 10, 20),
      GildedRose.Item.make("Aged Brie", 2, 0),
      GildedRose.Item.make("Elixir of the Mongoose", 5, 7),
      GildedRose.Item.make("Sulfuras, Hand of Ragnaros", 0, 80),
      GildedRose.Item.make("Sulfuras, Hand of Ragnaros", -1, 80),
      GildedRose.Item.make("Backstage passes to a TAFKAL80ETC concert", 15, 20),
      GildedRose.Item.make("Backstage passes to a TAFKAL80ETC concert", 10, 49),
      GildedRose.Item.make("Backstage passes to a TAFKAL80ETC concert", 5, 49),
      GildedRose.Item.make("Conjured Mana Cake", 3, 6)
    ].map(GildedRose.Item.toDomain)
};

var days = Belt_Option.mapWithDefault(Belt_Array.get(Process.argv, 2), 31, Caml_format.int_of_string);

for(var i = 0; i <= days; ++i){
  console.log("-------- day " + String(i) + " --------");
  console.log("name, sellIn, quality");
  for(var j = 0 ,j_finish = items.contents.length; j < j_finish; ++j){
    var item = Caml_array.get(items.contents, j);
    console.log(GildedRose.Domain.toString(item));
  }
  console.log("");
  items.contents = GildedRose.updateQuality(items.contents);
}

exports.items = items;
exports.days = days;
/*  Not a pure module */
