function btn_onclick() {
    var btn = document.getElementsByName("b1")[0];
    console.log(btn.value);
    
    if (btn.value == "Click") {
        btn.value = "提交";
    }else{
        btn.value = "Click";
    }
}
