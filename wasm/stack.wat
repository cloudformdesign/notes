(; C code
// https://mbebenita.github.io/WasmExplorer/
#include <stddef.h>

typedef struct {
    int a;
    int b;
} sum_struct_t;

__attribute__ ((noinline))
sum_struct_t sum_struct_create(int a, int b) {
  return (sum_struct_t){a, b};
}

int call_it() {
  sum_struct_t s = sum_struct_create(40, 2);
  return s.a + s.b;
}
;)

(module
  (type $type0 (func (param i32 i32 i32)))
  (type $type1 (func (result i32)))
  (memory 1) ;; 64KiB of memory
  (global $stack_ptr (mut i32) (i32.const 65536))
  (export "main" (func $main))
  (func $main (result i32)
        call $sum_local
  )

  (func $sum_struct_create (param $sum_struct_ptr i32) (param $var$a i32) (param $var$b i32)
    ;; c// sum_struct_ptr->a = a;
    get_local $sum_struct_ptr
    get_local $var$a
    i32.store

    ;; c// sum_struct_ptr->b = b;
    get_local $sum_struct_ptr
    get_local $var$b
    i32.store offset=4
  )

  (func $sum_local (result i32)
    (local $var0 i32) (local $var1 i32) (local $local_stack_ptr i32) 

    ;; reserve stack space and store local_stack_ptr
    (i32.sub
      (get_global $stack_ptr)
      (i32.const 16)
    )
    tee_local $local_stack_ptr
    set_global $stack_ptr

    ;; call the function, storing the result in the stack
    (call $sum_struct_create
      (i32.add
        (get_local $local_stack_ptr)
        (i32.const 8)
      )
      (i32.const 40)
      (i32.const 2)
    )

    (set_local $var0
      ;; ?? Nobody has touched this address
      (i32.load offset=8 (get_local $local_stack_ptr))
    )

    ( set_local $var1
      ;; ?? nor this address
      (i32.load offset=12 (get_local $local_stack_ptr))
    )

    ;; unreserve stack space
    (set_global $stack_ptr
        (i32.add
          (get_local $local_stack_ptr)
          (i32.const 16)
        )
    )

    get_local $var1
    get_local $var0
    i32.add
  )
)
