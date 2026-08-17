import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import numpy as np
import os

ARTIFACT_DIR = '/home/testuser/.gemini/antigravity/brain/5e50395f-82e2-410c-8245-e220228d8143'
os.makedirs(ARTIFACT_DIR, exist_ok=True)

# Configurações de estilo
plt.rcParams['font.sans-serif'] = 'DejaVu Sans'
BG_COLOR = '#0F172A'
CARD_BG = '#1E293B'
ACCENT_BLUE = '#38BDF8'
ACCENT_GREEN = '#10B981'
ACCENT_RED = '#EF4444'
ACCENT_AMBER = '#F59E0B'
TEXT_MAIN = '#F8FAFC'
TEXT_MUTED = '#94A3B8'

fig, axs = plt.subplots(2, 2, figsize=(16, 12), dpi=150, facecolor=BG_COLOR)
fig.suptitle('GUIA VISUAL PASSO A PASSO: COMO TESTAR CADA PEÇA', 
             fontsize=18, fontweight='bold', color=TEXT_MAIN, y=0.98)

# ==========================================
# PAINEL 1: TESTE DO FURO EM "D" NO MOTOR
# ==========================================
ax1 = axs[0, 0]
ax1.set_facecolor(CARD_BG)
ax1.set_title('1. Teste do Eixo D no Motor 28BYJ-48', color=ACCENT_BLUE, fontsize=13, fontweight='bold', pad=10)

# Desenhar Motor (Cinza Metálico)
motor_body = patches.Rectangle((-18, -12), 14, 24, facecolor='#475569', edgecolor='#94A3B8', lw=2)
ax1.add_patch(motor_body)
ax1.text(-11, 0, 'Motor\n28BYJ-48', color='#E2E8F0', fontsize=9, fontweight='bold', ha='center', va='center')

# Eixo metálico D
shaft = patches.Rectangle((-4, -3), 10, 6, facecolor='#CBD5E1', edgecolor='#94A3B8', lw=1.5)
ax1.add_patch(shaft)
# Chanfro D
d_flat = patches.Rectangle((-4, 1.8), 10, 1.2, facecolor='#94A3B8', edgecolor='none')
ax1.add_patch(d_flat)

# Pinhão Impresso entrando no eixo (Azul)
pinion = patches.Circle((14, 0), 9, facecolor='#0284C7', edgecolor=ACCENT_BLUE, lw=2, alpha=0.9)
ax1.add_patch(pinion)
# Dentes do pinhão
for angle in np.linspace(0, 2*np.pi, 10, endpoint=False):
    dx, dy = 10.5 * np.cos(angle), 10.5 * np.sin(angle)
    tooth = patches.Circle((14 + dx, dy), 1.6, facecolor=ACCENT_BLUE, edgecolor='#0284C7', lw=1)
    ax1.add_patch(tooth)

# Furo D interno do pinhão
furo_d = patches.Circle((14, 0), 3.2, facecolor=CARD_BG, edgecolor='#F8FAFC', lw=1.5)
ax1.add_patch(furo_d)
furo_flat = patches.Rectangle((10.8, 1.6), 6.4, 2.0, facecolor=CARD_BG, edgecolor='none')
ax1.add_patch(furo_flat)

# Seta de Ação
ax1.annotate('', xy=(7, 0), xytext=(0, 0),
             arrowprops=dict(facecolor=ACCENT_GREEN, edgecolor=ACCENT_GREEN, width=3, headwidth=9))

# Critérios
ax1.text(0, -16, '[APROVADO]: Entra justo apenas com a força dos dedos.\n[REPROVADO]: Frouxo (gira em falso) ou precisa de martelo.',
         color=TEXT_MAIN, fontsize=9.5, ha='center', va='center',
         bbox=dict(boxstyle='round,pad=0.5', facecolor='#0F172A', edgecolor='#334155'))

ax1.set_xlim(-22, 28)
ax1.set_ylim(-20, 16)
ax1.set_aspect('equal')
ax1.axis('off')

# ==========================================
# PAINEL 2: TESTE PINHÃO + CREMALHEIRA (RACK)
# ==========================================
ax2 = axs[0, 1]
ax2.set_facecolor(CARD_BG)
ax2.set_title('2. Teste de Engrenamento (Pinhão + Rack)', color=ACCENT_BLUE, fontsize=13, fontweight='bold', pad=10)

# Cremalheira (Base cinza + dentes triangulares)
rack_base = patches.Rectangle((-20, -10), 40, 4, facecolor='#475569', edgecolor='#94A3B8', lw=1.5)
ax2.add_patch(rack_base)
for rx in np.linspace(-18, 14, 9):
    triangle = patches.Polygon([[rx, -6], [rx+2, -2], [rx+4, -6]], facecolor='#64748B', edgecolor='#94A3B8', lw=1)
    ax2.add_patch(triangle)
ax2.text(0, -8, 'Cremalheira Curta', color='#E2E8F0', fontsize=9, fontweight='bold', ha='center', va='center')

# Pinhão engrenado
pinion2 = patches.Circle((0, 6), 7, facecolor='#0284C7', edgecolor=ACCENT_BLUE, lw=2, alpha=0.9)
ax2.add_patch(pinion2)
for angle in np.linspace(0, 2*np.pi, 10, endpoint=False):
    dx, dy = 8.5 * np.cos(angle), 8.5 * np.sin(angle)
    tooth = patches.Circle((dx, 6 + dy), 1.5, facecolor=ACCENT_BLUE, edgecolor='#0284C7', lw=1)
    ax2.add_patch(tooth)

# Seta de rotação e translação
ax2.annotate('Rolar suavemente\ncom os dedos', xy=(0, 6), xytext=(0, 16),
             ha='center', fontsize=9.5, color='#FCD34D', fontweight='bold',
             arrowprops=dict(facecolor='#F59E0B', edgecolor='#F59E0B', width=2, headwidth=7))
ax2.annotate('', xy=(12, 6), xytext=(-12, 6),
             arrowprops=dict(arrowstyle='<->', color=ACCENT_GREEN, lw=2.5))

ax2.text(0, -16, '[APROVADO]: Movimento contínuo, sem travar nem saltar dente.\n[REPROVADO]: Dentes raspando no fundo ou travando em pontos fixos.',
         color=TEXT_MAIN, fontsize=9.5, ha='center', va='center',
         bbox=dict(boxstyle='round,pad=0.5', facecolor='#0F172A', edgecolor='#334155'))


ax2.set_xlim(-24, 24)
ax2.set_ylim(-20, 20)
ax2.set_aspect('equal')
ax2.axis('off')

# ==========================================
# PAINEL 3: TESTE DO ANEL E GARFO (FOLGAS DO BOLSO)
# ==========================================
ax3 = axs[1, 0]
ax3.set_facecolor(CARD_BG)
ax3.set_title('3. Teste do Bolso do Motor (Anel Radial + Garfo)', color=ACCENT_BLUE, fontsize=13, fontweight='bold', pad=10)

# Sub-teste 3A: Anel Radial
ring_out = patches.Circle((-11, 4), 9, facecolor='#334155', edgecolor='#64748B', lw=1.5)
ring_in = patches.Circle((-11, 4), 7.2, facecolor=CARD_BG, edgecolor='#64748B', lw=1.5)
ax3.add_patch(ring_out)
ax3.add_patch(ring_in)
# Pinhão dentro do anel
p_in_ring = patches.Circle((-11, 4), 5.8, facecolor='#0284C7', edgecolor=ACCENT_BLUE, lw=1.5)
ax3.add_patch(p_in_ring)
ax3.text(-11, -7, 'Giro Radial 360°', color='#E2E8F0', fontsize=9, fontweight='bold', ha='center')

# Sub-teste 3B: Garfo Axial (U-Shape)
fork_base = patches.Rectangle((4, -3), 16, 3, facecolor='#475569', edgecolor='#94A3B8', lw=1.5)
fork_l = patches.Rectangle((4, 0), 3.5, 12, facecolor='#475569', edgecolor='#94A3B8', lw=1.5)
fork_r = patches.Rectangle((16.5, 0), 3.5, 12, facecolor='#475569', edgecolor='#94A3B8', lw=1.5)
ax3.add_patch(fork_base)
ax3.add_patch(fork_l)
ax3.add_patch(fork_r)

# Pinhão passando de lado entre as paredes
p_side = patches.Rectangle((8.5, 2), 7, 8, facecolor='#0284C7', edgecolor=ACCENT_BLUE, lw=1.5, alpha=0.9)
ax3.add_patch(p_side)
ax3.text(12, -7, 'Passagem Axial', color='#E2E8F0', fontsize=9, fontweight='bold', ha='center')

ax3.text(0, -15, '[APROVADO]: Gira livre no anel e passa no garfo sem esforço.\n[REPROVADO]: Pinhão raspa nas paredes do anel ou fica preso no garfo.',
         color=TEXT_MAIN, fontsize=9.5, ha='center', va='center',
         bbox=dict(boxstyle='round,pad=0.5', facecolor='#0F172A', edgecolor='#334155'))

ax3.set_xlim(-24, 26)
ax3.set_ylim(-19, 17)
ax3.set_aspect('equal')
ax3.axis('off')

# ==========================================
# PAINEL 4: TESTE DO MANDRIL + BUCHAS + CANETA
# ==========================================
ax4 = axs[1, 1]
ax4.set_facecolor(CARD_BG)
ax4.set_title('4. Teste do Porta-Ferramenta Z (Mandril + Buchas)', color=ACCENT_BLUE, fontsize=13, fontweight='bold', pad=10)

# Mandril (Corpo Cilíndrico com orelhas)
mandril_body = patches.Rectangle((-10, -5), 18, 18, facecolor='#475569', edgecolor='#94A3B8', lw=2)
ax4.add_patch(mandril_body)
# Orelha lateral com furo de aperto M3
ear = patches.Rectangle((8, -1), 6, 10, facecolor='#334155', edgecolor=ACCENT_AMBER, lw=1.5)
ax4.add_patch(ear)
bolt = patches.Circle((11, 4), 2.0, facecolor='#F59E0B', edgecolor='#FCD34D', lw=1)
ax4.add_patch(bolt)
ax4.text(11, 4, 'M3', color='#0F172A', fontsize=7, fontweight='bold', ha='center', va='center')

# Bucha Redutora inserida dentro
sleeve = patches.Rectangle((-7, -5), 12, 14, facecolor='#0284C7', edgecolor=ACCENT_BLUE, lw=1.5, alpha=0.7)
ax4.add_patch(sleeve)

# Caneta / Pincel passando pelo centro
pen = patches.Rectangle((-3.5, -9), 5, 24, facecolor='#F8FAFC', edgecolor='#94A3B8', lw=1.5)
ax4.add_patch(pen)
ax4.text(-1, -11, 'Caneta / Pincel', color='#F8FAFC', fontsize=8.5, fontweight='bold', ha='center')

ax4.annotate('Bucha\n(7.5 / 10 / 12.5mm)', xy=(-7, 6), xytext=(-19, 11),
             color='#38BDF8', fontsize=8.5, fontweight='bold',
             arrowprops=dict(arrowstyle='->', color='#38BDF8', lw=1.5))

ax4.text(0, -16, '[APROVADO]: Aperta a caneta firmemente com o M3 sem girar.\n[REPROVADO]: A bucha não entra no mandril ou a caneta desliza solta.',
         color=TEXT_MAIN, fontsize=9.5, ha='center', va='center',
         bbox=dict(boxstyle='round,pad=0.5', facecolor='#0F172A', edgecolor='#334155'))

ax4.set_xlim(-22, 22)
ax4.set_ylim(-20, 18)
ax4.set_aspect('equal')
ax4.axis('off')

plt.tight_layout(rect=[0, 0, 1, 0.95])
out_path = os.path.join(ARTIFACT_DIR, 'guia_visual_completo_testes.png')
plt.savefig(out_path, facecolor=BG_COLOR, edgecolor='none')
plt.close()
print(f"✓ Infográfico visual salvo em: {out_path}")
