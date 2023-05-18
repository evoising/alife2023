using Gadfly
using DataFrames
using CSV
using ColorSchemes: viridis
using Compose
import Cairo, Fontconfig

all= DataFrame(CSV.File("l25t.csv"))

palette=["blue","red"]

p=plot(all,x=:difference,y=:edges,color=:l,Geom.bar,Scale.color_discrete_manual(palette...),Guide.colorkey("",["T=0.15","T=0.45"],[0.65w,-0.28h]),Coord.Cartesian(xmin=-0.5,xmax=25.5,ymin=0.0,ymax=0.3),Guide.xticks(ticks=[5*n for n in 0:5]),Theme(bar_spacing=0.01inch,minor_label_font_size=10pt,key_label_font_size=10pt,background_color="white"))
draw(PNG("l25t.png",3.5inch, 2.5inch), p)

#,Guide.manual_color_key("",["T=0.15","T=0.45"], [palette[1], palette[2]],pos=[0.55w,-0.28h])
