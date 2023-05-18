#for the resubmission, adding the dotted line
#also I was missing a 2.0 in deltaE compared to the normal definition

using Gadfly
using DataFrames
using CSV
using ColorSchemes: viridis
using Compose
import Cairo, Fontconfig

palette = [ get(viridis, i) for i in range(0, length=10, stop=1) ]

ord = DataFrame(CSV.File("ord_short.csv"))
evo = DataFrame(CSV.File("evo_short.csv"))

l5asym=-0.448
    
evo[:, :energyNorm] = (evo[:, :energy].-l5asym)./(1+l5asym)

evo[:, :temperature] = evo[:, :temperature].*2.0
ord[:, :temperature] = ord[:, :temperature].*2.0


ordLayer=layer(ord,x=:temperature,y=:energy,Geom.line,color=[palette[1]])

evoLayer=layer(evo,x=:temperature,y=:energy,Geom.line,color=[palette[10]])

evoLayerNorm=layer(evo,x=:temperature,y=:energyNorm,Geom.line,color=[palette[10]],style(line_style=[:dot]))


p=plot(ordLayer,evoLayer,evoLayerNorm,Coord.Cartesian(xmin=0.0,xmax=2.0),Guide.xticks(ticks=[0.4*n for n in 0:5]),Guide.manual_color_key("",["ordinary", "preference"], [palette[1], palette[10]],pos=[0.05w,-0.28h]),Theme(minor_label_font_size=10pt,key_label_font_size=10pt,background_color="white"))
draw(PNG("energy.png",3.5inch, 2.5inch), p)
