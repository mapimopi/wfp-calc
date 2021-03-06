calculate = ->
  # ifl = "if less"
  # ifg = "if greater"
  # 0   = Пленка ORAJET 3640
  # 1   = Пленка ORAJET 3850 Транслюцентная
  # 2   = Бэклит
  # 3   = Перфорированная плёнка

  # 4   = Баннер 510 г/м2
  # 5   = Баннер 440 г/м2
  # 6   = Баннер транслюцентный
  # 7   = Баннер двухсторонний
  # 8   = Баннерная сетка

  # 9   = Фотобумага
  # 10  = Постерная бумага
  # 11  = Бумага (blue back)

  # 12  = Холст
  # 13  = Фотообои флизелиновы
  # 14  = Фотообои бумажные
  # 15  = Фотообои бумажные
  pricelist = {
    material_360_ifl: [
      245, 620, 470, 580,
      255, 190, 210, 330, 250,
      '-', 180, 105,
      '-', '-', '-', '-'
    ],
    material_360_ifg: [
      210, 540, 410, 505,
      220, 165, 180, 300, 215,
      '-', 155, 90,
      '-', '-', '-', '-'
    ],
    material_720_ifl: [
      385, 955, 700, 895,
      390, 310, 330, 525, 400,
      445, 280, 160,
      700, 1740, 635, 790
    ],
    material_720_ifg: [
      320, 830, 610, 775,
      340, 265, 280, 455, 350,
      385, 240, 140,
      610, 1510, 550, 685
    ],
    material_1440_ifl: [
      485, 1200, 875, 1115,
      490, 380, 375, 600, '-',
      555, 345, 200,
      875, 2175, 790, 985
    ],
    material_1440_ifg: [
      400, 1040, 760, 970,
      425, 330, 325, 520, '-',
      480, 300, 175,
      760, 1890, 685, 855
    ]

    postprint: {
      cut_perimeter: 10
      cut_outline: 312
      lamination: 220
      eyelet: 10
      gluing: 10
      rolling: 500
    }
  }


  material = Number($("select[name='material']").val())

  if material == 9
    if Number($("select[name='quality']").val()) == 360
      $("select[name='quality']").val('720')
    $("option[value='360']").prop('disabled','disabled').siblings().removeAttr('disabled');
  else if material == 8
    if Number($("select[name='quality']").val()) == 1440
      $("select[name='quality']").val('720')
    $("option[value='1440']").prop('disabled','disabled').siblings().removeAttr('disabled');
  else if material == 12 or material == 13 or material == 14 or material == 15
    if Number($("select[name='quality']").val()) == 360
      $("select[name='quality']").val('720')
    $("option[value='360']").prop('disabled','disabled').siblings().removeAttr('disabled');
  else
    $("option[value='360']").removeAttr('disabled')
    $("option[value='1440']").removeAttr('disabled')

  $("select[name='material']").find("option:selected").css('background-color: #f44')

  switch material
    when 0, 1, 3
      $('input[name="cut_perimeter"], input[name="cut_outline"], input[name="lamination"]').removeAttr('disabled')
      $('input[name="eyelets"], input[name="eyelets_radio"], input[name="gluing"]').prop('disabled','disabled')
    when 2, 11, 12, 13, 14, 15
      $('input[name="cut_perimeter"]').removeAttr('disabled')
      $('input[name="cut_outline"], input[name="lamination"], input[name="eyelets"], input[name="eyelets_radio"], input[name="gluing"]').prop('disabled','disabled')
    when 4, 5, 6, 7, 8
      $('input[name="cut_perimeter"], input[name="eyelets"], input[name="eyelets_radio"], input[name="gluing"]').removeAttr('disabled')
      $('input[name="cut_outline"], input[name="lamination"]').prop('disabled','disabled')
    when 9, 10
      $('input[name="cut_perimeter"], input[name="lamination"]').removeAttr('disabled')
      $('input[name="cut_outline"], input[name="eyelets"], input[name="eyelets_radio"], input[name="gluing"]').prop('disabled','disabled')
    else
      $('input[name="cut_perimeter"], input[name="cut_outline"], input[name="lamination"], input[name="eyelets"], input[name="eyelets_radio"], input[name="gluing"]').removeAttr('disabled')

  
  width = Number($("input[name='width']").val())
  length = Number($("input[name='length']").val())
  amount = Number($("input[name='amount']").val())

  if width < 0
    $("input[name='width']").prop('value', 0)
    width = 0
  if length < 0
    $("input[name='length']").prop('value', 0)
    length = 0
  if amount < 1
    $("input[name='amount']").prop('value', 1)
    amount = 1


  quality = Number($("select[name='quality']").val())
  options = {
    cut_perimeter: if $("input[name='cut_perimeter']").is(':disabled') then false else $("input[name='cut_perimeter']").is(':checked')
    cut_outline:   if $("input[name='cut_outline']").is(':disabled') then false else $("input[name='cut_outline']").is(':checked')
    lamination:    if $("input[name='lamination']").is(':disabled') then false else $("input[name='lamination']").is(':checked')
    gluing:        if $("input[name='gluing']").is(':disabled') then false else $("input[name='gluing']").is(':checked')
    rolling:       if $("input[name='rolling']").is(':disabled') then false else $("input[name='rolling']").is(':checked')
  }

  eyelets_option = Number($("input[name='eyelets_radio']:checked").val())

  if eyelets_option != 0
    $('input[name="gluing"]').prop('checked', true)
    options.gluing = true

  total_perimeter = (width + length) * 2 * amount
  total_meterage = width * length * amount

  if quality == 360
    if total_meterage < 100
      current_material_prices = pricelist.material_360_ifl
    else
      current_material_prices = pricelist.material_360_ifg
  else if quality == 720
    if total_meterage < 100
      current_material_prices = pricelist.material_720_ifl
    else
      current_material_prices = pricelist.material_720_ifg
  else if quality == 1440
    if total_meterage < 100
      current_material_prices = pricelist.material_1440_ifl
    else
      current_material_prices = pricelist.material_1440_ifg


  price = total_meterage * current_material_prices[material]

  if options.cut_perimeter
    price = price + total_perimeter * pricelist.postprint.cut_perimeter
  if options.cut_outline
    price = price + total_meterage * pricelist.postprint.cut_outline
  if options.lamination
    price = price + total_meterage * pricelist.postprint.lamination
  if eyelets_option == 4
    price = price + 4 * pricelist.postprint.eyelet * amount
  else if eyelets_option == 30
    price = price + total_perimeter / 0.3 * pricelist.postprint.eyelet
  else if eyelets_option == 50
    price = price + total_perimeter / 0.5 * pricelist.postprint.eyelet
  if options.gluing
    price = price + total_perimeter * pricelist.postprint.gluing
  if options.rolling
    price = price + total_meterage * pricelist.postprint.rolling

  if isNaN(price)
    price = "Несоответствующее качество печати"
  else
    price = price.toFixed(2) + " руб."


  if quality == 360
    time = Math.ceil(total_meterage / (65 * 8))
  else
    time = Math.ceil(total_meterage / (20 * 8))
  if total_meterage > 100
    time = time + 1


  if time % 10 == 1
    unless time % 100 == 11
      time = time + " день"
    else
      time = time + " дней"
  else if time % 10 > 1 and time % 10 < 5
    unless time % 100 > 11 and time % 100 < 15
      time = time + " дня"
    else
      time = time + " дней"
  else
    time = time + " дней"

  
  $("#price").html(price)
  $("#time").html(time)

  check_email()

check_email = ->
  $('input[id="submit"]').prop('disabled', false)    

  re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  if not re.test($("input[name='email']").val())
    $('input[id="submit"]').prop('disabled', true)

  if $("input[name='phone']").val().length < 10
    $('input[id="submit"]').prop('disabled', true)


jQuery ->
  $(document).ready -> calculate()
  $("form.calc").change -> calculate()
  $("input[name='material']").on('change', calculate)
  $("input[name='width']").on('input', calculate)
  $("input[name='height']").on('input', calculate)
  $("input[name='number']").on('input', calculate)
  $("input[name='email']").on('input', check_email)
  $("input[name='phone']").on('input', check_email)