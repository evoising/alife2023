using Gadfly
using DataFrames
using CSV
using ColorSchemes: viridis
using Compose
import Cairo, Fontconfig

palette = [ get(viridis, i) for i in range(0, length=10, stop=1) ]

ord = DataFrame(CSV.File("ord_short.csv"))
evo = DataFrame(CSV.File("evo_short.csv"))

ordLayer=layer(ord,x=:temperature,y=:energy,Geom.line,color=[palette[1]])

evoLayer=layer(evo,x=:temperature,y=:energy,Geom.line,color=[palette[10]])

p=plot(ordLayer,evoLayer,Coord.Cartesian(xmin=0.0,xmax=1.0),Guide.xticks(ticks=[0.2*n for n in 0:5]),Guide.manual_color_key("",["ordinary", "preference"], [palette[1], palette[10]],pos=[0.05w,-0.28h]),Theme(minor_label_font_size=10pt,key_label_font_size=10pt,background_color="white"))
draw(PDF("energy.pdf",2.5inch, 2inch), p)
