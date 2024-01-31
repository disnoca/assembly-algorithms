; Dynamic Array implementation
; @author Samuel Pires

section .text

extern Malloc
extern Free
extern Realloc
extern memmove

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
;		int* arr;
;		int size, capacity;
;	} DynamicArray;

; Header Implementation

; DynamicArray* (int capacity)
da_create:
	push rbp
	mov rbp, rsp
	sub rsp, 16
	mov [rbp - 8], edi
	mov edi, 16
	call Malloc					; allocate the struct
	mov [rbp - 16], rax
	mov edi, [rbp - 8]
	sal edi, 2					; calculate the array size
	call Malloc					; allocate the array
	mov rcx, rax
	mov rax, [rbp - 16]
	mov [rax], rcx				; set the array pointer
	mov dword [rax + 8], 0		; set the size to 0
	mov ecx, [rbp - 8]
	mov [rax + 12], ecx			; set the capacity
	leave
	ret

; void (DynamicArray* da, int data)
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

;void (DynamicArray* da, int data, int pos)
da_add_at:
	cmp edx, [rdi + 8]
	je da_add					; do regular add if pos = size
	push rbp
	mov rbp, rsp
	sub rsp, 32
	mov [rbp - 8], rdi
	mov [rbp - 12], esi
	mov [rbp - 16], edx
	mov eax, [rdi + 8]
	mov [rbp - 20], eax
	cmp eax, [rdi + 12]
	jl da_add_at_end
	call resize
	mov rdi, [rbp - 8]
	mov rsi, [rbp - 12]
	mov edx, [rbp - 16]
	mov eax, [rbp - 20]

da_add_at_end:
	mov rdi, [rdi]
	mov rsi, rdi
	sal edx, 2
	add rsi, rdx				; calculate source pos
	add rdi, rdx	
	add rdi, 4					; calculate dest pos
	sal eax, 2
	sub eax, edx				; calculate amount to move
	mov edx, eax
	call memmove				; shift elements to the right
	mov rax, [rbp - 8]
	mov rcx, [rax]
	mov edx, [rbp - 12]
	mov edi, [rbp - 16]
	mov [rcx + rdi * 4], edx	; put element in pos
	inc dword [rax + 8]			; increase size
	leave
	ret

; int (DynamicArray* da)
da_remove_last:
	push rbp
	mov rbp, rsp
	dec dword [rdi + 8]			; decrease size
	mov rax, [rdi]
	mov ecx, [rdi + 8]
	mov eax, [rax + rcx * 4]	; get last element
	leave
	ret

; int (DynamicArray* da, int pos);
da_remove_at:
	inc esi
	cmp esi, [rdi + 8]
	je da_remove_last			; do remove_last if pos = size - 1
	dec esi
	push rbp
	mov rbp, rsp
	sub rsp, 16
	mov [rbp - 8], rdi
	mov edx, [rdi + 8]
	mov rdi, [rdi]
	mov eax, [rdi + rsi * 4]	; get element at pos
	mov [rbp - 12], eax
	sal esi, 2
	sal edx, 2
	sub edx, esi				; calculate amount to move
	add rdi, rsi				; calculate dest pos
	mov rsi, rdi
	add rsi, 4					; calculate source pos
	call memmove				; shift elements to the left
	mov eax, [rbp - 12]
	mov rcx, [rbp - 8]
	dec dword [rcx + 8]			; decrease size
	leave
	ret

; bool (DynamicArray* da, int data);
da_remove:
	call da_index_of
	test eax, eax
	js da_remove_err
	mov esi, eax
	call da_remove_at
	mov eax, 1
	ret

da_remove_err:
	mov eax, 0
	ret

; int (DynamicArray* da, int pos);
da_get:
	mov rax, [rdi]
	mov eax, [rax + rsi * 4]
	ret

; int (DynamicArray* da, int data, int pos);
da_set:
	mov rcx, [rdi]
	mov eax, [rcx + rdx * 4]
	mov [rcx + rdx * 4], rsi
	ret

; int (DynamicArray* da, int data);
da_index_of:
	mov rax, [rdi]
	xor ecx, ecx
	mov edx, [rdi + 8]

da_index_of_loop:
	cmp ecx, edx
	jge da_index_of_err
	cmp esi, [rax + rcx * 4]
	je da_index_of_end
	inc ecx
	jmp da_index_of_loop

da_index_of_err:
	mov ecx, -1

da_index_of_end:
	mov eax, ecx
	ret

; bool (DynamicArray* da, int data);
da_contains:
	call da_index_of
	xor ecx, ecx
	test eax, eax
	mov eax, 1
	cmovs eax, ecx
	ret

; void (DynamicArray* da);
da_clear:
	mov dword [rdi + 8], 0
	ret

;void (DynamicArray* da)
da_destroy:
	push rbp
	mov rbp, rsp
	sub rsp, 16
	mov rax, [rdi]
	mov [rbp - 8], rax
	call Free
	mov rdi, [rbp - 8]
	call Free
	leave
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
