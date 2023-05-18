using Gadfly
using DataFrames
using CSV
using ColorSchemes: viridis
using Compose
import Cairo, Fontconfig

palette = [ get(viridis, i) for i in range(0, length=10, stop=1) ]


evol5 = DataFrame(CSV.File("evo_short.csv"))
evol25 = DataFrame(CSV.File("evol25_short.csv"))

l5asym=-0.448
l25asym=-0.204
    
evol5[:, :energy] = (evol5[:, :energy].-l5asym)./(1+l5asym)
evol25[:, :energy] = (evol25[:, :energy].-l25asym)./(1+l25asym)

l5Layer=layer(evol5,x=:temperature,y=:energy,Geom.line,color=[palette[10]])

l25Layer=layer(evol25,x=:temperature,y=:energy,Geom.line,color=[palette[8]])

p=plot(l5Layer,l25Layer,Coord.Cartesian(xmin=0.0,xmax=1.0),Guide.xticks(ticks=[0.2*n for n in 0:5]),Guide.manual_color_key("",["L=5", "L=25"], [palette[10], palette[8]],pos=[0.05w,-0.28h]),Theme(minor_label_font_size=10pt,key_label_font_size=10pt,background_color="white"))
draw(PNG("energy_l25.png",3.5inch, 2.5inch), p)
