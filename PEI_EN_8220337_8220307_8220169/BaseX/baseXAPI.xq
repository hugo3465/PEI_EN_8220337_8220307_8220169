module namespace page = 'http://basex.org/examples/web-page';

(: Globas variables:)
declare variable $url := "https://eu-west-2.aws.data.mongodb-api.com/app/data-krpco/endpoint/data/v1";
declare variable $findSuffix := "/action/findOne";
declare variable $apiKey := "suGjpm3S5Uue7H3sCuTLlKKxPBsWmXI8gf9x7Qx0yXegqquTrnNvuXo21SrXthBb";
declare variable $contentType := "application/json";

(: Obter relatório de vendas de um mês :)
declare
 %rest:path("/getSale?nome={$primeiroNome $ultimoNome},ano={$ano},mes={$mes}")
 %rest:GET
function page:getSale($primeiroNome as xs:string, $ultimoTempo as xs:string, $ano as xs:int, $mes as xs:int) {
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