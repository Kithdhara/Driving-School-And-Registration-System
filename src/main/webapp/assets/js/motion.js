document.addEventListener('DOMContentLoaded', () => {
    initScrollAnimations();
    initMagneticButtons();
    initPasswordToggles();
    initUrlToasts();
    initTabs();
});

/* ═══════════════════════════════════════════════════════════════
   SCROLL ANIMATIONS
   ═══════════════════════════════════════════════════════════════ */
function initScrollAnimations() {
    const observerOptions = {
        root: null,
        rootMargin: '0px 0px -50px 0px',
        threshold: 0.1
    };

    const observer = new IntersectionObserver((entries, obs) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const target = entry.target;
                
                const container = target.closest('.motion-container');
                if (container) {
                    const siblings = Array.from(container.querySelectorAll('.motion-item'));
                    const index = siblings.indexOf(target);
                    
                    if (index > -1) {
                        target.style.transitionDelay = `${index * 75}ms`;
                    }
                }

                requestAnimationFrame(() => {
                    target.classList.add('motion-visible');
                });
                
                obs.unobserve(target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('.motion-item, .motion-pop').forEach(el => {
        observer.observe(el);
    });
}

/* ═══════════════════════════════════════════════════════════════
   MAGNETIC BUTTONS
   ═══════════════════════════════════════════════════════════════ */
function initMagneticButtons() {
    const buttons = document.querySelectorAll('.magnetic-btn');
    
    buttons.forEach(btn => {
        btn.addEventListener('mousemove', (e) => {
            const rect = btn.getBoundingClientRect();
            const x = e.clientX - rect.left - rect.width / 2;
            const y = e.clientY - rect.top - rect.height / 2;
            
            btn.style.transform = `translate(${x * 0.2}px, ${y * 0.2}px)`;
        });
        
        btn.addEventListener('mouseleave', () => {
            btn.style.transform = `translate(0px, 0px)`;
        });
    });
}

/* ═══════════════════════════════════════════════════════════════
   PASSWORD VISIBILITY TOGGLE
   ═══════════════════════════════════════════════════════════════ */
function initPasswordToggles() {
    document.querySelectorAll('.password-toggle').forEach(btn => {
        btn.addEventListener('click', () => {
            const input = btn.previousElementSibling || btn.parentElement.querySelector('input[type="password"], input[type="text"]');
            if (input) {
                const isPassword = input.type === 'password';
                input.type = isPassword ? 'text' : 'password';
                const icon = btn.querySelector('.material-symbols-outlined');
                if (icon) {
                    icon.textContent = isPassword ? 'visibility' : 'visibility_off';
                }
            }
        });
    });
}

/* ═══════════════════════════════════════════════════════════════
   TOAST NOTIFICATIONS (from URL params)
   ═══════════════════════════════════════════════════════════════ */
function initUrlToasts() {
    const params = new URLSearchParams(window.location.search);
    const success = params.get('success');
    const error = params.get('error');

    if (success) showToast(success, 'success');
    if (error) showToast(error, 'error');

    // Clean URL
    if (success || error) {
        const url = new URL(window.location);
        url.searchParams.delete('success');
        url.searchParams.delete('error');
        window.history.replaceState({}, '', url);
    }
}

function showToast(message, type) {
    let container = document.querySelector('.toast-container');
    if (!container) {
        container = document.createElement('div');
        container.className = 'toast-container';
        document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;

    const iconMap = { success: 'check_circle', error: 'error', info: 'info' };
    toast.innerHTML = `
        <span class="material-symbols-outlined" style="font-size:18px;">${iconMap[type] || 'info'}</span>
        <span>${message}</span>
    `;

    container.appendChild(toast);

    setTimeout(() => {
        toast.classList.add('toast-out');
        setTimeout(() => toast.remove(), 300);
    }, 4000);
}

/* ═══════════════════════════════════════════════════════════════
   TAB SYSTEM
   ═══════════════════════════════════════════════════════════════ */
function initTabs() {
    const tabButtons = document.querySelectorAll('.tab-btn[data-tab]');
    if (tabButtons.length === 0) return;

    tabButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            const tabName = btn.getAttribute('data-tab');
            switchTab(tabName);
        });
    });

    // Check URL hash for tab
    const hash = window.location.hash.replace('#', '');
    if (hash && document.getElementById('panel-' + hash)) {
        switchTab(hash);
    }
}

function switchTab(tabName) {
    // Hide all panels
    document.querySelectorAll('.tab-panel').forEach(p => {
        p.classList.remove('active');
    });
    // Reset all tab buttons
    document.querySelectorAll('.tab-btn[data-tab]').forEach(b => {
        b.classList.remove('active');
    });
    // Show target panel
    const panel = document.getElementById('panel-' + tabName);
    if (panel) panel.classList.add('active');
    // Activate target tab button
    const activeBtn = document.querySelector(`.tab-btn[data-tab="${tabName}"]`);
    if (activeBtn) activeBtn.classList.add('active');
}

/* ═══════════════════════════════════════════════════════════════
   FORM VALIDATION HELPERS
   ═══════════════════════════════════════════════════════════════ */
const Validator = {
    showError(inputId, message) {
        const input = document.getElementById(inputId);
        const errorEl = document.getElementById(inputId + 'Error');
        if (input) input.classList.add('field-error');
        if (errorEl) {
            errorEl.textContent = message;
            errorEl.classList.add('visible');
        }
    },

    clearErrors(formId) {
        const form = document.getElementById(formId);
        if (!form) return;
        form.querySelectorAll('.field-error').forEach(el => el.classList.remove('field-error'));
        form.querySelectorAll('.error-message').forEach(el => {
            el.textContent = '';
            el.classList.remove('visible');
        });
    },

    isValidEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    },

    isValidPhone(phone) {
        return /^0\d{9}$/.test(phone);
    },

    isValidPassword(password) {
        return /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&]).{6,}$/.test(password);
    },

    isLettersOnly(str) {
        return /^[A-Za-z\s]+$/.test(str);
    },

    isValidNIC(nic) {
        // Sri Lankan NIC: old format (9 digits + V/X) or new format (12 digits)
        return /^(\d{9}[VvXx]|\d{12})$/.test(nic);
    },

    isFutureDate(dateStr) {
        const date = new Date(dateStr);
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        return date >= today;
    },

    isValidCardNumber(number) {
        const digits = number.replace(/\s/g, '');
        return /^\d{16}$/.test(digits);
    },

    formatCardNumber(input) {
        let value = input.value.replace(/\D/g, '');
        let formatted = value.replace(/(.{4})/g, '$1 ').trim();
        input.value = formatted;
    }
};

/* ═══════════════════════════════════════════════════════════════
   SWEETALERT2 CONFIRM HELPERS
   ═══════════════════════════════════════════════════════════════ */
function confirmDelete(url, itemName) {
    if (typeof Swal === 'undefined') {
        if (confirm('Are you sure you want to delete this ' + itemName + '?')) {
            window.location.href = url;
        }
        return;
    }
    Swal.fire({
        title: 'Delete ' + itemName + '?',
        text: "This action cannot be undone.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ef4444',
        cancelButtonColor: '#64748b',
        confirmButtonText: 'Yes, delete it',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = url;
        }
    });
}

function confirmAction(url, title, text, confirmText, icon) {
    if (typeof Swal === 'undefined') {
        if (confirm(title + '\n' + text)) {
            window.location.href = url;
        }
        return;
    }
    Swal.fire({
        title: title,
        text: text,
        icon: icon || 'question',
        showCancelButton: true,
        confirmButtonColor: '#4f46e5',
        cancelButtonColor: '#64748b',
        confirmButtonText: confirmText || 'Confirm',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = url;
        }
    });
}

function confirmLogout() {
    if (typeof Swal === 'undefined') {
        window.location.href = 'LogoutServlet';
        return;
    }
    Swal.fire({
        title: 'Sign Out?',
        text: 'You will be redirected to the login page.',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#0f172a',
        cancelButtonColor: '#64748b',
        confirmButtonText: 'Sign Out',
        cancelButtonText: 'Stay'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = 'LogoutServlet';
        }
    });
}

function confirmDeleteAccount(formId) {
    if (typeof Swal === 'undefined') {
        if (confirm('This will PERMANENTLY delete your account. Are you absolutely sure?')) {
            document.getElementById(formId).submit();
        }
        return;
    }
    Swal.fire({
        title: 'Delete Your Account?',
        html: '<p style="color:#64748b;">This action is <strong style="color:#ef4444;">permanent</strong> and cannot be undone. All your data will be lost.</p>',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ef4444',
        cancelButtonColor: '#64748b',
        confirmButtonText: 'Yes, delete my account',
        cancelButtonText: 'Keep my account'
    }).then((result) => {
        if (result.isConfirmed) {
            document.getElementById(formId).submit();
        }
    });
}
