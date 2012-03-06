var init = function init() {

  var map = new L.Map('map');
  var osmUrl = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  var osmAttribution = 'Map data copyright openstreetmap contributers';
  var osmLayer = new L.TileLayer(osmUrl, {minZoom:0, maxZoom: 18, attribution: osmAttribution});

  var geojsonLayer;

  map.setView(new L.LatLng(52, 13), 12);
  map.addLayer(osmLayer);

  var addGeoJSONLayer = function(geoJSON) {

    if(geojsonLayer) {
      map.removeLayer(geojsonLayer);
    }

    geojsonLayer = new L.GeoJSON();

    geojsonLayer.on('featureparse', function(feature){
      var html = [
        'OSM Id: <a href=\'http://openstreetmap.org/browse/relation/' + feature.id + '\'>' + feature.id + '</a>',
        '<a target=\'_blank\' href=\'http://localhost:3000/api/postcodes/' + feature.id + '\'>download as GeoJSON</a>',
        'Postal code: ' + feature.properties.postalCode
      ];
      feature.layer.bindPopup(html.join('<br>'));
    });

    geojsonLayer.addGeoJSON(geoJSON);

    map.addLayer(geojsonLayer);
  };

  //$.getJSON('./api/postcodes/1435433?callback=?', addGeoJSONLayer);
  $.getJSON('./api/postcodes?bbox=[' + map.getBounds().toBBoxString() + ']&callback=?', addGeoJSONLayer);


  map.on('moveend', function(event){
    if(map.getZoom() >= 10) {
      $.getJSON('./api/postcodes?bbox=[' + map.getBounds().toBBoxString() + ']&callback=?', addGeoJSONLayer);
    }
  });

};
