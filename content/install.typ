#import "template.typ": template
#import "@rheo/rookery:0.1.0": footnote, idea, ideas-outline, todo

#show: template.with(current-page: "install")
#set document(
  title: "Install",
  date: datetime(year: 2026, month: 8, day: 15),
)

#ideas-outline()

#idea("installing", title: [Installing rookery])[
  The easiest way to get started with a rookery is by #link("https://rheo.ohrg.org/getting-started")[installing Rheo], a typesetting engine based on Typst.
  #footnote[If you prefer to use native Typst to compile a rookery, see @idea:using-typst]

  Once you have `rheo` on your path, you can use rookery in your Rheo project by importing it and hatching an idea:

  ```typ
  #import "@rheo/rookery:0.1.0": idea
  #idea[I want to hatch ideas with rookery.]
  ```

  That's it!
  You're now ready to build out a rookery.

]

#todo("configuring", title: [Configuring rookery])[

]
