; Dynamic Array implementation
; @author Samuel Pires

section .text

extern Malloc
extern Free
extern Realloc
extern memcpy

global da_create
global da_add
global da_add_at
global da_remove_last
global da_remove_at
global da_remove
global da_get
global da_set
global da_index_of
global da_contains
global da_clear
global da_destroy

;	typedef struct {
;		data_type* arr;
;		int size, capacity;
;	} DynamicArray;

; Header Implementation

	;endbr64
	;pushq	%rbp
	;.cfi_def_cfa_offset 16
	;.cfi_offset 6, -16
	;movq	%rsp, %rbp
	;.cfi_def_cfa_register 6
	;subq	$32, %rsp
	;movl	%edi, -20(%rbp)
	;movl	$16, %edi

; DynamicArray* (int capacity)
da_create:
	push rbp
	mov rbp, rsp
	sub rsp, 16
	mov [rbp - 8], edi
	mov edi, 16
	call Malloc				; allocate the struct
	mov [rbp - 16], rax
	mov edi, [rbp - 8]
	sal edi, 2				; calculate the array size
	call Malloc				; allocate the array
	mov rcx, rax
	mov rax, [rbp - 16]
	mov [rax], rcx			; set the array pointer
	mov dword [rax + 8], 0	; set the size to 0
	mov ecx, [rbp - 8]
	mov [rax + 12], ecx		; set the capacity
	leave
	ret

; void (DynamicArray* da, data_type data)
da_add:
	push rbp
	mov rbp, rsp
	mov eax, [rdi + 8]
	cmp eax, [rdi + 12]
	jl da_add_end
	push rdi
	push rsi
	call resize
	pop rsi
	pop rdi

da_add_end:
	mov eax, [rdi]
	mov ecx, [rdi + 8]
	mov [eax + ecx * 4], esi
	inc dword [rdi + 8]	
	leave
	ret

da_add_at:
	ret

da_remove_last:
	ret

da_remove_at:
	ret

da_remove:
	ret

da_get:
	ret

da_set:
	ret

da_index_of:
	ret

da_contains:
	ret

da_clear:
	ret

da_destroy:
	ret


; Helper Functions

; void (DynamicArray* da)
resize:
	push rbp
	mov rbp, rsp
	sub rsp, 16
	sal dword [rdi + 12], 1		; double the capacity
	mov esi, [rdi + 12]
	shl esi, 2					; calculate new array size
	mov [rbp - 8], rdi
	mov rdi, [rdi]
	call Realloc
	mov [rdi], rax
	mov rdi, [rbp - 8]
	leave
	ret
