using Gadfly
using DataFrames
using CSV
using ColorSchemes: viridis
using Compose
import Cairo, Fontconfig

palette = [ get(viridis, i) for i in range(0, length=10, stop=1)]


evo = DataFrame(CSV.File("evo_l25.csv"))
ord = DataFrame(CSV.File("ord_l25.csv"))
both= DataFrame(CSV.File("l25.csv"))
both[!,:color] = palette[both[!,:l]]

p=plot(evo,x=:difference,y=:edges,Geom.bar,color=[palette[10]],Coord.Cartesian(xmin=-0.5,xmax=25.5,ymin=0.0,ymax=0.25),Guide.xticks(ticks=[5*n for n in 0:5]),Theme(bar_spacing=0.1inch,minor_label_font_size=10pt,key_label_font_size=10pt,background_color="white"))
draw(PNG("evo_hist_l25.png",3.5inch, 2.5inch), p)

p=plot(ord,x=:difference,y=:edges,Geom.bar,color=[palette[1]],Coord.Cartesian(xmin=-0.5,xmax=25.5,ymin=0.0,ymax=0.25),Guide.xticks(ticks=[5*n for n in 0:5]),Theme(bar_spacing=0.1inch,minor_label_font_size=10pt,key_label_font_size=10pt,background_color="white"))
draw(PNG("ord_hist_l25.png",3.5inch, 2.5inch), p)


p=plot(both,x=:difference,y=:edges,color=:color,Geom.bar,Coord.Cartesian(xmin=-0.5,xmax=25.5,ymin=0.0,ymax=0.2),Guide.xticks(ticks=[5*n for n in 0:5]),Guide.manual_color_key("",["ordinary", "preference"], [palette[1], palette[8]],pos=[0.35w,-0.28h]),Theme(bar_spacing=0.01inch,minor_label_font_size=10pt,key_label_font_size=10pt,background_color="white"))
draw(PNG("l25_hist.png",2.8inch, 2.0inch), p)
draw(SVG("l25_hist.svg",2.8inch, 2.0inch), p)

#was 3.5x2.5inch for paper, changed to 2.8x2.0inch for grant
#pos was 0.55w for paper, changed to 0.35w for grant