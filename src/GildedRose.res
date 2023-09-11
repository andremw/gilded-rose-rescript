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
}

let upTo50 = Js.Math.min_int(50, _)
let min0 = Js.Math.max_int(0, _)

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
    | name if name->Js.String2.startsWith("Conjured") => {
        ...item,
        sellIn: item.sellIn - 1,
        // TODO: improve this to always be twice as fast as normal items
        quality: switch (item.sellIn, item.quality) {
        | (0, _) => item.quality - 4
        | (_, quality) => min0(quality - 2)
        },
      }
    | _ => {
        ...item,
        sellIn: item.sellIn - 1,
        quality: switch (item.sellIn, item.quality) {
        | (0, _) => item.quality - 2
        | (_, quality) => min0(quality - 1)
        },
      }
    }
  })
}
