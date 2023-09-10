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

  test("Aged Brie's quality does not go over 50", () => {
    let item: Item.t = {
      sellIn: 1,
      quality: 50,
      name: "Aged Brie",
    }

    [item]->updateQuality->expect->toEqual([{...item, sellIn: 0, quality: 50}])
  })

  test("Sulfuras quality is 80 and it never changes", () => {
    let item: Item.t = {
      sellIn: 1,
      quality: 80,
      name: "Sulfuras, Hand of Ragnaros",
    }

    [item]->updateQuality->expect->toEqual([{...item, sellIn: 1, quality: 80}])
  })

  describe("Backstage passes", () => {
    test(
      "quality drops to 0 after sellIn expires",
      () => {
        let item: Item.t = {
          sellIn: 0,
          quality: 10,
          name: "Backstage passes to a TAFKAL80ETC concert",
        }

        [item]->updateQuality->expect->toEqual([{...item, sellIn: -1, quality: 0}])
      },
    )

    test(
      "quality increases by 1 when sellIn is more than 10",
      () => {
        let item: Item.t = {
          sellIn: 11,
          quality: 10,
          name: "Backstage passes to a TAFKAL80ETC concert",
        }

        [item]->updateQuality->expect->toEqual([{...item, sellIn: 10, quality: 11}])
      },
    )

    test(
      "quality increases by 2 if 5 < sellIn <= 10",
      () => {
        let item: Item.t = {
          sellIn: 10,
          quality: 10,
          name: "Backstage passes to a TAFKAL80ETC concert",
        }

        [item]->updateQuality->expect->toEqual([{...item, sellIn: 9, quality: 12}])
      },
    )

    test(
      "quality increases by 3 if 0 < sellIn <= 5",
      () => {
        let item: Item.t = {
          sellIn: 5,
          quality: 10,
          name: "Backstage passes to a TAFKAL80ETC concert",
        }

        [item]->updateQuality->expect->toEqual([{...item, sellIn: 4, quality: 13}])
      },
    )

    test(
      "quality does not go over 50",
      () => {
        let item: Item.t = {
          sellIn: 5,
          quality: 48,
          name: "Backstage passes to a TAFKAL80ETC concert",
        }

        [item]->updateQuality->expect->toEqual([{...item, sellIn: 4, quality: 50}])
      },
    )
  })
})
