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
      if (
        newItem.contents.name != "Aged Brie" &&
          newItem.contents.name != "Backstage passes to a TAFKAL80ETC concert"
      ) {
        if newItem.contents.quality > 0 {
          if newItem.contents.name != "Sulfuras, Hand of Ragnaros" {
            newItem := {...newItem.contents, quality: newItem.contents.quality - 1}
          }
        }
      } else if newItem.contents.quality < 50 {
        newItem := {...newItem.contents, quality: newItem.contents.quality + 1}

        if newItem.contents.name == "Backstage passes to a TAFKAL80ETC concert" {
          if newItem.contents.sellIn < 11 {
            if newItem.contents.quality < 50 {
              newItem := {...newItem.contents, quality: newItem.contents.quality + 1}
            }
          }

          if newItem.contents.sellIn < 6 {
            if newItem.contents.quality < 50 {
              newItem := {...newItem.contents, quality: newItem.contents.quality + 1}
            }
          }
        }
      }

      if newItem.contents.name != "Sulfuras, Hand of Ragnaros" {
        newItem := {...newItem.contents, sellIn: newItem.contents.sellIn - 1}
      }

      if newItem.contents.sellIn < 0 {
        if newItem.contents.name != "Aged Brie" {
          if newItem.contents.name != "Backstage passes to a TAFKAL80ETC concert" {
            if newItem.contents.quality > 0 {
              if newItem.contents.name != "Sulfuras, Hand of Ragnaros" {
                newItem := {...newItem.contents, quality: newItem.contents.quality - 1}
              }
            }
          } else {
            newItem := {
                ...newItem.contents,
                quality: newItem.contents.quality - newItem.contents.quality,
              }
          }
        } else if newItem.contents.quality < 50 {
          newItem := {...newItem.contents, quality: newItem.contents.quality + 1}
        }
      }
    }

    newItem.contents
  })
}
