open Jest
open Expect
open GildedRose

describe("Gilded Rose", () => {
  test("quality cannot be lower than 0", () => {
    let item: Item.t = {
      sellIn: 1,
      quality: 0,
      name: "Whatever",
    }

    [item]->updateQuality->expect->toEqual([{...item, sellIn: 0, quality: 0}])
  })

  test("after sellIn expires quality degrades twice as fast", () => {
    let item: Item.t = {
      sellIn: 0,
      quality: 10,
      name: "Whatever",
    }

    [item]->updateQuality->expect->toEqual([{...item, sellIn: -1, quality: 8}])
  })

  test("Aged Brie's quality increases as the days go by", () => {
    let item: Item.t = {
      sellIn: 1,
      quality: 10,
      name: "Aged Brie",
    }

    [item]->updateQuality->expect->toEqual([{...item, sellIn: 0, quality: 11}])
  })

  test("Sulfuras quality is 80 and it never changes", () => {
    let item: Item.t = {
      sellIn: 1,
      quality: 80,
      name: "Sulfuras, Hand of Ragnaros",
    }

    [item]->updateQuality->expect->toEqual([{...item, sellIn: 1, quality: 80}])
  })
})
