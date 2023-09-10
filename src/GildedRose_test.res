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
})
