#import "template.typ": template
#import "@rheo/rookery:0.1.0": idea, ideas-outline, todo

#show: template.with(current-page: "install")
#set document(
  title: "Install",
  date: datetime(year: 2026, month: 8, day: 15),
)

#ideas-outline()

#todo("installing", title: [Installing rookery])[
]

#todo("configuring", title: [Configuring rookery])[

]
