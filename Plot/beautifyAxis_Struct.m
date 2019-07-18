function st = beautifyAxis_Struct()


st.h_fig.Position=[100 100 200 200];


st.h_axes.FontName='Arial';
st.h_axes.Box='off';
st.h_axes.TickDir='out';
st.h_axes.TickLength=[.02 .02];
st.h_axes.XMinorTick='on';
st.h_axes.YMinorTick='on';
st.h_axes.YGrid='on';
st.h_axes.XColor=[.3 .3 .3];
st.h_axes.YColor=[.3 .3 .3];
st.h_axes.GridAlpha = .08;
st.h_axes.LineWidth=1;
st.h_axes.FontSize=8;

st.h_yruler.Linewidth = 0.25;
st.h_legend.FontSize = 8;
st.h_xlabel.FontSize=9.5;
st.h_ylabel.FontSize=9.5;


end