module namespace page = 'http://basex.org/examples/web-page';

(: Obter relatório de vendas de um mês :)
declare
 %rest:path("/getSale?ano={$ano},mes={$mes}")
 %rest:GET
function page:getSale($ano as xs:int, $mes as xs:int) {
  let $xsd := "./xsd/saleRules.xsd"
  (: validate:xsd($sale, $xsd) :)
};

(: Obter relatório de devoluçções de um mês :)
declare
 %rest:path("/getReturn?ano={$ano},mes={$mes}")
 %rest:GET
function page:getReturn($ano as xs:int, $mes as xs:int) {
  let $xsd := "./xsd/saleRules.xsd"
  if(validate:xsd($sale, $xsd))
};