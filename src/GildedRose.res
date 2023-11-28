let upTo50 = Js.Math.min_int(50, _)
let min0 = Js.Math.max_int(0, _)

module Domain = {
  type item =
    | AgedBrie({name: string, sellIn: int, quality: int})
    | Sulfuras({name: string})
    | BackstagePasses({name: string, sellIn: int, quality: int})
    | Conjured({name: string, sellIn: int, quality: int})
    | Other({name: string, sellIn: int, quality: int})

  let updateQuality = (item: item) =>
    switch item {
    | AgedBrie({name, sellIn, quality}) =>
      AgedBrie({name, sellIn: sellIn - 1, quality: upTo50(quality + 1)})
    | Sulfuras(data) => Sulfuras(data)
    | BackstagePasses({name, sellIn, quality}) =>
      BackstagePasses({
        name,
        sellIn: sellIn - 1,
        quality: switch (sellIn, quality) {
        | (_, 50) => 50
        | (0, _) => 0
        | (sellIn, quality) if sellIn <= 5 => upTo50(quality + 3)
        | (sellIn, quality) if sellIn <= 10 => upTo50(quality + 2)
        | (_, quality) => upTo50(quality + 1)
        },
      })
    | Conjured({name, sellIn, quality}) =>
      Conjured({
        name,
        sellIn: sellIn - 1,
        quality: switch (sellIn, quality) {
        | (0, _) => quality - 2 * 2
        | (_, quality) => min0(quality - 1 * 2)
        },
      })
    | Other({name, sellIn, quality}) =>
      Other({
        name,
        sellIn: sellIn - 1,
        quality: switch (sellIn, quality) {
        | (0, _) => quality - 2
        | (_, quality) => min0(quality - 1)
        },
      })
    }
}

module Item = {
  type t = {
    name: string,
    sellIn: int,
    quality: int,
  }

  let make = (~name, ~sellIn, ~quality): t => {
    name,
    sellIn,
    quality,
  }

  let toDomain = (item: t) => {
    open Domain
    switch item.name {
    | "Aged Brie" =>
      AgedBrie({
        name: item.name,
        sellIn: item.sellIn,
        quality: item.quality,
      })
    | "Sulfuras, Hand of Ragnaros" => Sulfuras({name: item.name})
    | "Backstage passes to a TAFKAL80ETC concert" =>
      BackstagePasses({
        name: item.name,
        sellIn: item.sellIn,
        quality: item.quality,
      })
    | name =>
      switch name->Js.String2.startsWith("Conjured") {
      | true =>
        Conjured({
          name: item.name,
          sellIn: item.sellIn,
          quality: item.quality,
        })
      | false =>
        Other({
          name: item.name,
          sellIn: item.sellIn,
          quality: item.quality,
        })
      }
    }
  }
}

let updateQuality = (items: array<Item.t>) => {
  items->Js.Array2.map(item => {
    switch item.name {
    | "Aged Brie" => {
        ...item,
        sellIn: item.sellIn - 1,
        quality: upTo50(item.quality + 1),
      }
    | "Sulfuras, Hand of Ragnaros" => item
    | "Backstage passes to a TAFKAL80ETC concert" => {
        ...item,
        sellIn: item.sellIn - 1,
        quality: switch (item.sellIn, item.quality) {
        | (_, 50) => 50
        | (0, _) => 0
        | (sellIn, quality) if sellIn <= 5 => upTo50(quality + 3)
        | (sellIn, quality) if sellIn <= 10 => upTo50(quality + 2)
        | (_, quality) => upTo50(quality + 1)
        },
      }
    | _ =>
      let degradationRate = item.name->Js.String2.startsWith("Conjured") ? 2 : 1

      {
        ...item,
        sellIn: item.sellIn - 1,
        quality: switch (item.sellIn, item.quality) {
        | (0, _) => item.quality - 2 * degradationRate
        | (_, quality) => min0(quality - 1 * degradationRate)
        },
      }
    }
  })
}
