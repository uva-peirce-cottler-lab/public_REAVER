function fixTableScroll(directoryTable,value)

	jUIScrollPane = findjobj(directoryTable) ;
	jUITable	  = jUIScrollPane.getViewport.getView ;
	jUITable.changeSelection(value-1,0, false, false) ;
	
	  % get the current position of the scroll
% 	scroll = jUIScrollPane.getVerticalScrollBar.getValue ;
% 	drawnow
% 	jUIScrollPane.getVerticalScrollBar.setValue(scroll);     % set scroll position to the end

%         jscrollpane = javaObjectEDT( findjobj(directoryTable) );
%         viewport    = javaObjectEDT( jscrollpane.getViewport );
%         jtable      = javaObjectEDT( viewport.getView );
%         jtable.scrollRowToVisible( value );

end

