import 'package:flutter/material.dart';
import '../l10n/education_translations.dart';
import '../state/app_state.dart';

class EducationArticle {
  final String id;
  final String title;
  final String summary;
  final String body;
  final int readingTimeMinutes;
  final IconData icon;
  final String category;

  const EducationArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.body,
    required this.readingTimeMinutes,
    required this.icon,
    this.category = 'general',
  });

  String getTitle(BuildContext context) {
    final state = AppStateProvider.maybeOf(context);
    final lang = state?.languageCode ?? 'en';
    return educationTranslations[lang]?['${id}_title'] ?? title;
  }

  String getSummary(BuildContext context) {
    final state = AppStateProvider.maybeOf(context);
    final lang = state?.languageCode ?? 'en';
    return educationTranslations[lang]?['${id}_summary'] ?? summary;
  }

  String getBody(BuildContext context) {
    final state = AppStateProvider.maybeOf(context);
    final lang = state?.languageCode ?? 'en';
    return educationTranslations[lang]?['${id}_body'] ?? body;
  }
}

class EducationData {
  static const List<EducationArticle> articles = [
    EducationArticle(
      id: 'what_is_sciatica',
      title: 'What Is Sciatica?',
      summary: 'Understanding the sciatic nerve and what causes sciatica pain.',
      readingTimeMinutes: 3,
      icon: Icons.info_outline,
      category: 'understanding',
      body: '''Sciatica refers to pain that radiates along the path of the sciatic nerve — the longest nerve in your body. It branches from your lower back through your hips, buttocks, and down each leg.

**What causes it?**
Sciatica most commonly occurs when a herniated disc, bone spur, or spinal stenosis compresses part of the nerve. This causes inflammation, pain, and often numbness in the affected leg.

**Key facts:**
• The sciatic nerve is about as thick as your thumb
• It runs from the lower spine (L4-S3) all the way to your feet
• About 40% of people will experience sciatica at some point in their lives
• It usually affects only one side of the body

**Common causes:**
• Herniated or bulging disc (most common)
• Piriformis syndrome — tight piriformis muscle compressing the nerve
• Spinal stenosis — narrowing of the spinal canal
• Degenerative disc disease
• Spondylolisthesis — vertebra slipping forward

**The good news:** Most cases of sciatica resolve within 4-6 weeks with conservative treatment including stretching, gentle exercise, and proper posture management. Surgery is rarely needed.''',
    ),
    EducationArticle(
      id: 'sleeping_positions',
      title: 'Best Sleeping Positions',
      summary: 'How to sleep comfortably with sciatica and reduce morning pain.',
      readingTimeMinutes: 2,
      icon: Icons.bedtime,
      category: 'posture',
      body: '''Poor sleeping positions can compress the sciatic nerve and make morning pain much worse. Here's how to sleep for relief:

**Best positions:**

🟢 **Side sleeping with a pillow between the knees**
This is the gold standard. It keeps your spine, hips, and pelvis aligned. Use a firm pillow between your knees and draw them up slightly toward your chest.

🟢 **On your back with a pillow under your knees**
This reduces pressure on your lower spine. Place a pillow under your knees to maintain the natural curve of your back. A small rolled towel under your lower back can help too.

🟢 **Foetal position (for herniated discs)**
Lie on your side and gently curl into a foetal position. This opens up the space between vertebrae and can relieve nerve pressure.

**Positions to avoid:**

🔴 **Stomach sleeping** — this flattens the natural curve of your spine and puts strain on your lower back.

🔴 **Twisted positions** — avoid lying with your torso twisted in a different direction from your hips.

**Mattress tips:**
• A medium-firm mattress is generally best
• If your mattress is too soft, try placing a plywood board underneath it
• Replace your mattress every 8-10 years
• Consider a memory foam topper for pressure relief''',
    ),
    EducationArticle(
      id: 'sitting_posture',
      title: 'Correct Sitting Posture',
      summary: 'How to sit properly to prevent sciatica flare-ups at work.',
      readingTimeMinutes: 2,
      icon: Icons.chair,
      category: 'posture',
      body: '''Sitting for long periods is one of the biggest triggers for sciatica. Here's how to sit smarter:

**The ideal setup:**

🪑 **Chair height:** Your feet should be flat on the floor with thighs parallel to the ground. Knees at 90 degrees.

🪑 **Back support:** Use a lumbar support cushion or rolled-up towel in the curve of your lower back. Your back should be fully supported.

🪑 **Screen position:** The top of your screen should be at eye level. This prevents you from hunching forward.

**The 20-20-20 rule:**
Every 20 minutes, stand for 20 seconds and look at something 20 feet away. Set a timer on your phone.

**Key principles:**
• Never cross your legs — this tilts the pelvis
• Keep your wallet out of your back pocket (it creates uneven pressure)
• Stand up and walk for 2-3 minutes every 30 minutes
• Avoid soft, deep sofas — they round your lower back
• When driving, move the seat forward so you don't have to reach for the pedals

**Red flag:** If your job requires sitting for 8+ hours, consider a sit-stand desk. Standing for even 15 minutes per hour makes a significant difference.''',
    ),
    EducationArticle(
      id: 'movements_to_avoid',
      title: 'Movements to Avoid',
      summary: 'Exercises and activities that can make sciatica worse.',
      readingTimeMinutes: 2,
      icon: Icons.do_not_disturb,
      category: 'safety',
      body: '''Some exercises that are great for general fitness can actually make sciatica significantly worse. Here's what to avoid:

**🔴 Avoid these exercises:**

**Toe touches (standing):** Bending forward with straight legs puts enormous pressure on the discs and can worsen nerve compression.

**Heavy squats and deadlifts:** The compressive load on the spine can aggravate a herniated disc. Avoid until your physiotherapist clears you.

**Leg presses:** The seated position combined with heavy resistance compresses the lower spine.

**Sit-ups and crunches:** These flex the spine aggressively and can push disc material further into the nerve.

**High-impact activities:** Running, jumping, and high-impact aerobics jar the spine. Switch to walking, swimming, or cycling.

**🔴 Avoid these daily activities:**

• Bending and twisting simultaneously (e.g., loading a dishwasher)
• Lifting heavy objects from the floor — always bend your knees
• Sitting on the floor cross-legged for extended periods
• Wearing high heels — they tilt the pelvis forward

**✅ Safe alternatives:**
• Walking (low impact, promotes healing)
• Swimming (zero spinal load)
• Gentle yoga (avoid deep forward bends)
• Stationary cycling (adjust seat height properly)
• The exercises in this app!''',
    ),
    EducationArticle(
      id: 'recovery_timeline',
      title: 'Recovery Timeline',
      summary: 'How long sciatica recovery really takes and what to expect.',
      readingTimeMinutes: 3,
      icon: Icons.timeline,
      category: 'understanding',
      body: '''Recovery from sciatica varies, but here's what most people experience:

**Weeks 1-2: Acute phase**
Pain is at its worst. Focus on gentle movement, ice/heat therapy, and avoiding positions that trigger pain. Don't force stretches — do only what feels comfortable.

**Weeks 2-4: Early recovery**
Pain begins to centralise (move from the leg toward the lower back). This is actually a good sign — it means the nerve is becoming less compressed. Continue gentle stretches and start introducing basic strengthening.

**Weeks 4-8: Active recovery**
Most people see significant improvement. You can progressively add more challenging exercises. The pain should be noticeably less frequent and less intense.

**Weeks 8-12: Strengthening phase**
Focus shifts to building core strength and flexibility to prevent recurrence. Pain may flare occasionally but episodes should be shorter.

**3-6 months: Maintenance**
Most cases fully resolve. Continue regular exercise to prevent recurrence. About 80-90% of sciatica cases resolve without surgery.

**Important notes:**
• Recovery is NOT linear — expect good days and bad days
• A temporary increase in pain after exercise is normal (as long as it settles within 30 minutes)
• Consistency beats intensity — 10 minutes daily is better than 60 minutes once a week
• If pain increases progressively over weeks, see a healthcare provider
• Numbness or weakness in the leg that gets worse needs immediate medical attention

**When to see a doctor urgently:**
• Loss of bladder or bowel control
• Progressive weakness in the leg
• Numbness in the saddle area
• Pain that worsens despite rest for more than 6 weeks''',
    ),
    EducationArticle(
      id: 'heat_vs_cold',
      title: 'Heat vs Cold Therapy',
      summary: 'When to use heat and when to use ice for sciatica pain.',
      readingTimeMinutes: 2,
      icon: Icons.thermostat,
      category: 'treatment',
      body: '''Both heat and cold can help with sciatica, but they work differently and should be used at different times:

**❄️ Cold therapy (Ice)**
Best for: Acute flare-ups (first 48-72 hours)

How it works: Reduces inflammation and numbs the painful area. Cold constricts blood vessels, limiting swelling.

How to use:
• Wrap ice in a towel (never apply directly to skin)
• Apply for 15-20 minutes at a time
• Wait at least 2 hours between applications
• Focus on the lower back or buttock area

**🔥 Heat therapy**
Best for: Ongoing pain, tight muscles, before exercise

How it works: Relaxes tight muscles, increases blood flow, promotes healing. Heat helps muscles stretch more easily.

How to use:
• Use a heating pad, hot water bottle, or warm bath
• Apply for 15-20 minutes at a time
• Great before doing your stretches — warms up the muscles
• A warm shower directed at the lower back works too

**The combination approach:**
Many physiotherapists recommend alternating: 10 minutes cold, 10 minutes off, 10 minutes heat. This creates a "pumping" effect that reduces inflammation while promoting blood flow.

**Rule of thumb:** If the area is swollen or it's a new flare-up, start with cold. If the muscles feel tight and stiff, use heat.''',
    ),
  ];
}
