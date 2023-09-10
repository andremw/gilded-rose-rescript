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
    let newItem = ref(item)

    switch newItem.contents.name {
    | "Aged Brie" =>
      newItem := {
          ...newItem.contents,
          sellIn: newItem.contents.sellIn - 1,
          quality: upTo50(newItem.contents.quality + 1),
        }
    | "Sulfuras, Hand of Ragnaros" => newItem := newItem.contents
    | "Backstage passes to a TAFKAL80ETC concert" =>
      newItem := {
          ...newItem.contents,
          sellIn: newItem.contents.sellIn - 1,
          quality: switch (newItem.contents.sellIn, newItem.contents.quality) {
          | (_, 50) => 50
          | (0, _) => 0
          | (sellIn, quality) if sellIn <= 5 => upTo50(quality + 3)
          | (sellIn, quality) if sellIn <= 10 => upTo50(quality + 2)
          | (_, quality) => upTo50(quality + 1)
          },
        }
    | _ =>
      newItem := {
          ...newItem.contents,
          sellIn: newItem.contents.sellIn - 1,
          quality: switch (newItem.contents.sellIn, newItem.contents.quality) {
          | (0, _) => newItem.contents.quality - 2
          | (_, quality) => min0(quality - 1)
          },
        }
    }

    newItem.contents
  })
}
