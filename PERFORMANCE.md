#1 - no lazy loading  in gallery_screen.dart leading to loading all 500 images at once
therefore causing janky frames 

return SingleChildScrollView(
controller: _scrollController,
child: Column(
children: [
_buildHeader(context, photos),
ListView(
shrinkWrap: true,
physics: const NeverScrollableScrollPhysics(),
children: [
for (final photo in photos) PhotoCard(photo: photo),
],
),
],
),
);

 shrinkWrap: true, caused lazyLoading to stop and load all 500 images to the view 


replaced with this >>

return ListView.builder(
controller: _scrollController,
itemCount: photos.length + 1,
itemBuilder: (BuildContext context, int index) {
if (index == 0) {
return _buildHeader(context, photos);
}
return PhotoCard(photo: photos[index - 1]);
},
);


#2  