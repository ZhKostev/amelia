# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class @TagShow
  @PROCESSED_IMAGES_COUNT = 0
  @LABELS_STORE = {}
  @AMOUNT_OF_RECORDS_PER_BAR_CHART = 5

  @init: (tagSearchId) =>
    App.TagSearchChannel = App.cable.subscriptions.create { channel: "TagSearchChannel", tag_search_id: tagSearchId },
      received: (response) =>
        info = response['data']
        TagShow.PROCESSED_IMAGES_COUNT += 1
        for label in info['labels']
          unless TagShow.LABELS_STORE[label[0]]?
            TagShow.LABELS_STORE[label[0]] = { weight: 0, count: 0 }
          TagShow.LABELS_STORE[label[0]]['weight'] += label[1]
          TagShow.LABELS_STORE[label[0]]['count'] += 1
        TagShow.blurImage(info['image_path'], info['labels'])
        $('#processed_img_h .badge').text(TagShow.PROCESSED_IMAGES_COUNT)
        $('#labels_img_h .badge').text(Object.keys(TagShow.LABELS_STORE).length)
        TagShow.drawLabelsPopularityCountsChart()
        TagShow.drawLabelsCountsChart()

  @blurImage: (imagePath, labels) =>
    $img = $('img[src="'+ imagePath + '"]')
    $img.siblings('.parsing-img-gif').remove()
    $img.addClass('img-processed')
    $img.parent().append(@blurImageTextHtml(labels))

  @blurImageTextHtml: (labels) =>
    html = '<div class="img-labels-overlay">'
    for label in labels
      html += label[0] + ' - ' + parseFloat(label[1]).toFixed(2) + '<br/>'
    html += '</div>'

  @drawLabelsCountsChart: =>
    $('#labels_counts_bar_chart_canvas').siblings('.loading-gif').remove()
    $('#labels_counts_bar_chart_canvas').replaceWith('<canvas id="labels_counts_bar_chart_canvas"></canvas>')
    labels = []
    data = []
    info = @fetchOrderedLabels((elem) ->
      elem['count']
    ).reverse().slice(0, TagShow.AMOUNT_OF_RECORDS_PER_BAR_CHART)
    for elem in info
      labels.push(elem[0])
      data.push(elem[1])
    new Chart( document.getElementById("labels_counts_bar_chart_canvas").getContext('2d'), {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: '# of labels',
          data: data,
          backgroundColor: Array(TagShow.AMOUNT_OF_RECORDS_PER_BAR_CHART).join('rgba(54, 162, 235, 0.2);').split(';'),
          borderColor: Array(TagShow.AMOUNT_OF_RECORDS_PER_BAR_CHART).join('rgba(54, 162, 235, 1);').split(';'),
          borderWidth: 1
        }]
      },
      options: {
        scales: {
          yAxes: [{
            ticks: {
              beginAtZero:true
            }
          }]
        }
      }
    });

  @drawLabelsPopularityCountsChart: =>
    $('#labels_popularity_bar_chart_canvas').siblings('.loading-gif').remove()
    $('#labels_popularity_bar_chart_canvas').replaceWith('<canvas id="labels_popularity_bar_chart_canvas"></canvas>')
    labels = []
    data = []
    info = @fetchOrderedLabels((elem) ->
      elem['weight'] / elem['count']
    ).reverse().slice(0, TagShow.AMOUNT_OF_RECORDS_PER_BAR_CHART)
    for elem in info
      labels.push(elem[0])
      data.push(elem[1])
    new Chart( document.getElementById("labels_popularity_bar_chart_canvas").getContext('2d'), {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: 'avg weight',
          data: data,
          backgroundColor: Array(TagShow.AMOUNT_OF_RECORDS_PER_BAR_CHART).join('rgba(75, 192, 192, 0.2);').split(';'),
          borderColor: Array(TagShow.AMOUNT_OF_RECORDS_PER_BAR_CHART).join('rgba(75, 192, 192, 1);').split(';'),
          borderWidth: 1
        }]
      },
      options: {
        scales: {
          yAxes: [{
            ticks: {
              beginAtZero:true
            }
          }]
        }
      }
    });

  @fetchOrderedLabels: (callback) =>
    tmpArr = []
    for label, info of @LABELS_STORE
      tmpArr.push([label, callback(info)])
    tmpArr.sort (a, b) ->
      a[1] - b[1]

