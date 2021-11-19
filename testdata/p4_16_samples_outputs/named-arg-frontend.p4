extern void f(in bit<16> x, in bool y);
control c() {
    @name("c.xv") bit<16> xv_0;
    @name("c.b") bool b_0;
    apply {
        xv_0 = 16w0;
        b_0 = true;
        f(y = b_0, x = xv_0);
    }
}

control empty();
package top(empty _e);
top(c()) main;

