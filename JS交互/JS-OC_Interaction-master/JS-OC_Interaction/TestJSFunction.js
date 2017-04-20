var factorial = function(n) {
    if (n < 0) return;
    if (n === 0) return 1;
    return n * factorial(n - 1)
};
var testFunction01 = function() {
    //alert('点击按钮');
    var msg = ocFunc();
    alert(msg);
};
var testFunction02 = function() {
    var msg = testObject.testOCMethodWithFirstParamSecondMethod('uiwebview', 123);
    alert(msg);
}