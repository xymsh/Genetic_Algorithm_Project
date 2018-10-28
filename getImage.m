function he = getImage()
[filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' });
he = imread([pathname,filename]);
he=im2double(he);
he=imresize(he,[150,150]);