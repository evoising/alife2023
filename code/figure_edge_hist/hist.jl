using Gadfly
using DataFrames
using CSV
using ColorSchemes: viridis
using Compose
import Cairo, Fontconfig

palette = [ get(viridis, i) for i in range(0, length=10, stop=1) 
               ]
evo = DataFrame(CSV.File("evo.csv"))
ord = DataFrame(CSV.File("ord.csv"))

p=plot(evo,x=:difference,y=:edges,Geom.bar,color=[palette[8]],Coord.Cartesian(xmin=-0.5,xmax=5.5,ymin=0.0,ymax=0.55),Guide.xticks(ticks=[n for n in 0:5]),Theme(bar_spacing=0.1inch,minor_label_font_size=10pt,key_label_font_size=10pt,background_color="white"))
draw(PNG("evo_hist.png",2.8inch, 2.0inch), p)

p=plot(ord,x=:difference,y=:edges,Geom.bar,color=[palette[1]],Coord.Cartesian(xmin=-0.5,xmax=5.5,ymin=0.0,ymax=0.55),Guide.xticks(ticks=[n for n in 0:5]),Theme(bar_spacing=0.1inch,minor_label_font_size=10pt,key_label_font_size=10pt,background_color="white"))
draw(PNG("ord_hist.png",2.8inch, 2.0inch), p)

#was 3.5x2.5inch for paper, changed to 2.8x2.0inch for grant
#palette[10] in paper, changed to palette[8] for grant