open Jest
open Expect
open GildedRose

describe("Gilded Rose", () => {
  describe("Item", () => {
    test(
      "converts item to AgedBrie",
      () => {
        let item: Item.t = {
          sellIn: 1,
          quality: 1,
          name: "Aged Brie",
        }

        item
        ->Item.toDomain
        ->expect
        ->toEqual(
          AgedBrie({
            sellIn: 1,
            quality: 1,
            name: "Aged Brie",
          }),
        )
      },
    )

    test(
      "converts item to Sulfuras",
      () => {
        let item: Item.t = {
          sellIn: 1,
          quality: 1,
          name: "Sulfuras, Hand of Ragnaros",
        }

        item
        ->Item.toDomain
        ->expect
        ->toEqual(
          Sulfuras({
            name: "Sulfuras, Hand of Ragnaros",
          }),
        )
      },
    )

    test(
      "converts item to BackstagePass",
      () => {
        let item: Item.t = {
          sellIn: 1,
          quality: 1,
          name: "Backstage passes to a TAFKAL80ETC concert",
        }

        item
        ->Item.toDomain
        ->expect
        ->toEqual(
          BackstagePasses({
            sellIn: 1,
            quality: 1,
            name: "Backstage passes to a TAFKAL80ETC concert",
          }),
        )
      },
    )

    test(
      "converts item to Conjured",
      () => {
        let item: Item.t = {
          sellIn: 1,
          quality: 1,
          name: "Conjured Mana Cake",
        }

        item
        ->Item.toDomain
        ->expect
        ->toEqual(
          Conjured({
            sellIn: 1,
            quality: 1,
            name: "Conjured Mana Cake",
          }),
        )
      },
    )

    test(
      "converts item to Other",
      () => {
        let item: Item.t = {
          sellIn: 1,
          quality: 1,
          name: "Whatever",
        }

        item
        ->Item.toDomain
        ->expect
        ->toEqual(
          Other({
            sellIn: 1,
            quality: 1,
            name: "Whatever",
          }),
        )
      },
    )
  })

  test("quality cannot be lower than 0", () => {
    let item: Item.t = {
      sellIn: 1,
      quality: 0,
      name: "Whatever",
    }

    [item->Item.toDomain]
    ->updateQuality
    ->expect
    ->toEqual([Other({name: "Whatever", sellIn: 0, quality: 0})])
  })

  test("after sellIn expires quality degrades twice as fast", () => {
    let item: Item.t = {
      sellIn: 0,
      quality: 10,
      name: "Whatever",
    }

    [item->Item.toDomain]
    ->updateQuality
    ->expect
    ->toEqual([Other({name: "Whatever", sellIn: -1, quality: 8})])
  })

  test("Aged Brie's quality increases as the days go by", () => {
    let item: Item.t = {
      sellIn: 1,
      quality: 10,
      name: "Aged Brie",
    }

    [item->Item.toDomain]
    ->updateQuality
    ->expect
    ->toEqual([AgedBrie({name: "Aged Brie", sellIn: 0, quality: 11})])
  })

  test("Aged Brie's quality does not go over 50", () => {
    let item: Item.t = {
      sellIn: 1,
      quality: 50,
      name: "Aged Brie",
    }

    [item->Item.toDomain]
    ->updateQuality
    ->expect
    ->toEqual([AgedBrie({name: "Aged Brie", sellIn: 0, quality: 50})])
  })

  test("Sulfuras quality is 80 and it never changes", () => {
    let item: Item.t = {
      sellIn: 1,
      quality: 80,
      name: "Sulfuras, Hand of Ragnaros",
    }

    [item->Item.toDomain]
    ->updateQuality
    ->expect
    ->toEqual([Sulfuras({name: "Sulfuras, Hand of Ragnaros"})])
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

        [item->Item.toDomain]
        ->updateQuality
        ->expect
        ->toEqual([
          BackstagePasses({
            name: "Backstage passes to a TAFKAL80ETC concert",
            sellIn: -1,
            quality: 0,
          }),
        ])
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

        [item->Item.toDomain]
        ->updateQuality
        ->expect
        ->toEqual([
          BackstagePasses({
            name: "Backstage passes to a TAFKAL80ETC concert",
            sellIn: 10,
            quality: 11,
          }),
        ])
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

        [item->Item.toDomain]
        ->updateQuality
        ->expect
        ->toEqual([
          BackstagePasses({
            name: "Backstage passes to a TAFKAL80ETC concert",
            sellIn: 9,
            quality: 12,
          }),
        ])
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

        [item->Item.toDomain]
        ->updateQuality
        ->expect
        ->toEqual([
          BackstagePasses({
            name: "Backstage passes to a TAFKAL80ETC concert",
            sellIn: 4,
            quality: 13,
          }),
        ])
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

        [item->Item.toDomain]
        ->updateQuality
        ->expect
        ->toEqual([
          BackstagePasses({
            name: "Backstage passes to a TAFKAL80ETC concert",
            sellIn: 4,
            quality: 50,
          }),
        ])
      },
    )
  })

  describe("Conjured item", () => {
    test(
      "Quality degrades twice as fast as normal items",
      () => {
        let item: Item.t = {
          sellIn: 1,
          quality: 10,
          name: "Conjured Mana Cake",
        }

        [item->Item.toDomain]
        ->updateQuality
        ->expect
        ->toEqual([Conjured({name: "Conjured Mana Cake", sellIn: 0, quality: 8})])
      },
    )

    test(
      "quality degrades super fast after expiring",
      () => {
        let item: Item.t = {
          sellIn: 0,
          quality: 10,
          name: "Conjured Mana Cake",
        }

        [item->Item.toDomain]
        ->updateQuality
        ->expect
        ->toEqual([Conjured({name: "Conjured Mana Cake", sellIn: -1, quality: 6})])
      },
    )
  })
})
