///////////////////////////////////////////////////////////////////////
//Glasses
/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
          // in a lit area (via pixel_x,y or smooth movement), can see those pixels
BLIND     // can't see anything
*/
///////////////////////////////////////////////////////////////////////

/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/glasses.dmi'
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_EYES
	plane_slots = list(slot_glasses)
	var/vision_flags = 0
	var/darkness_view = 0//Base human is 2
	var/see_invisible = -1
	var/prescription = 0
	var/toggleable = 0
	var/off_state = "degoggles"
	var/active = 1
	var/activation_sound = 'sound/items/goggles_charge.ogg'
	var/obj/screen/overlay = null
	var/list/away_planes //Holder for disabled planes
	price_tag = 15

	sprite_sheets = list(
		"Teshari" = 'icons/mob/species/seromi/eyes.dmi',
		"Vox" = 'icons/mob/species/vox/eyes.dmi'
		)

/obj/item/clothing/glasses/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_glasses()

/obj/item/clothing/glasses/attack_self(mob/user)
	if(toggleable)
		if(active)
			active = 0
			icon_state = off_state
			user.update_inv_glasses()
			flash_protection = FLASH_PROTECTION_NONE
			tint = TINT_NONE
			away_planes = enables_planes
			enables_planes = null
			to_chat(usr, "You deactivate the optical matrix on the [src].")
		else
			active = 1
			icon_state = initial(icon_state)
			user.update_inv_glasses()
			flash_protection = initial(flash_protection)
			tint = initial(tint)
			enables_planes = away_planes
			away_planes = null
			to_chat(usr, "You activate the optical matrix on the [src].")
		user.update_action_buttons()
		user.recalculate_vis()

/obj/item/clothing/glasses/meson
	name = "optical meson scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	item_state_slots = list(slot_r_hand_str = "meson", slot_l_hand_str = "meson")
	action_button_name = "Toggle Goggles"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	toggleable = 1
	vision_flags = SEE_TURFS
	enables_planes = list(VIS_FULLBRIGHT, VIS_MESONS)
	price_tag = 150

/obj/item/clothing/glasses/meson/New()
	..()
	overlay = global_hud.meson

/obj/item/clothing/glasses/meson/prescription
	name = "prescription mesons"
	desc = "Optical Meson Scanner with prescription lenses."
	prescription = 1

/obj/item/clothing/glasses/meson/aviator
	name = "engineering aviators"
	icon_state = "aviator_eng"
	off_state = "aviator"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")
	action_button_name = "Toggle HUD"
	activation_sound = 'sound/effects/pop.ogg'

/obj/item/clothing/glasses/meson/aviator/prescription
	name = "prescription engineering aviators"
	desc = "Engineering Aviators with prescription lenses."
	prescription = 1

/obj/item/clothing/glasses/hud/health/aviator
	name = "medical HUD aviators"
	desc = "Modified aviator glasses with a toggled health HUD."
	icon_state = "aviator_med"
	off_state = "aviator"
	action_button_name = "Toggle Mode"
	toggleable = 1
	activation_sound = 'sound/effects/pop.ogg'

/obj/item/clothing/glasses/hud/health/aviator/prescription
	name = "prescription medical HUD aviators"
	desc = "Modified aviator glasses with a toggled health HUD. Comes with bonus prescription lenses."
	prescription = 6

/obj/item/clothing/glasses/science
	name = "Science Goggles"
	desc = "The goggles do nothing!"
	icon_state = "purple"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	toggleable = 1
	action_button_name = "Toggle Goggles"
	item_flags = AIRTIGHT

/obj/item/clothing/glasses/science/New()
	..()
	overlay = global_hud.science

/obj/item/clothing/glasses/goggles
	name = "goggles"
	desc = "Just some plain old goggles."
	icon_state = "plaingoggles"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	item_flags = AIRTIGHT
	body_parts_covered = EYES

/obj/item/clothing/glasses/night
	name = "night vision goggles"
	desc = "You can totally see in the dark now!"
	icon_state = "night"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	origin_tech = list(TECH_MAGNET = 2)
	darkness_view = 7
	toggleable = 1
	action_button_name = "Toggle Goggles"
	off_state = "denight"
	flash_protection = FLASH_PROTECTION_REDUCED
	enables_planes = list(VIS_FULLBRIGHT)

/obj/item/clothing/glasses/night/vox
	name = "Alien Optics"
	species_restricted = list("Vox")
	phoronproof = 1

/obj/item/clothing/glasses/night/New()
	..()
	overlay = global_hud.nvg

/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	desc = "Yarr."
	icon_state = "eyepatch"
	item_state_slots = list(slot_r_hand_str = "blindfold", slot_l_hand_str = "blindfold")
	body_parts_covered = 0
	var/flipped = FALSE // Indicates left or right eye; 0 = on the right

/obj/item/clothing/glasses/eyepatch/verb/switcheye()
	set name = "Flip Patch"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(!usr.canmove || usr.stat || usr.restrained()) return
	src.flipped = !src.flipped

	if(src.flipped) //Will check whether icon state is currently set to the flipped or not flipped state and switch it around with a message to the user. Flip to right eye
		icon_state = "[icon_state]_r"
		usr << "You change \the [src] to cover your right eye."
	else if(!src.flipped) //Flip to left eye
		if(icon_state == "hudpatch_r")
			icon_state = "hudpatch"
		else
			icon_state = initial(icon_state)
		usr << "You change \the [src] to cover your left eye."
	else //in case some goofy admin switches icon states around without switching the icon_open or icon_closed
		usr << "You reach to flip \the [src], but it is already on your [src.flipped ? "left" : "right"] eye."
		return
	update_clothing_icon()	//so our overlays update

/////eyepatch Variants begin/////
/obj/item/clothing/glasses/eyepatch/hud
	name = "iPatch"
	desc = "A cost-effective removable eye prosthetic. It connects directly to the optical nerve of the user, replacing the need for that useless eyeball."
	icon_state = "hudpatch"
	off_state = "hudpatch"
	action_button_name = "Toggle iPatch"
	toggleable = 1

/obj/item/clothing/glasses/eyepatch/hud/New()
	.  = ..()
	update_icon()

/obj/item/clothing/glasses/eyepatch/hud/attack_self()
	..()
	update_icon()

/obj/item/clothing/glasses/eyepatch/hud/security
	name = "SECpatch"
	desc = "A Security-type heads-up display that connects directly to the optical nerve of the user, replacing the need for that useless eyeball."
	icon_state = "secpatch"
	off_state = "hudpatch"
	action_button_name = "Toggle HUD"
	toggleable = 1
	enables_planes = list(VIS_CH_ID,VIS_CH_WANTED,VIS_CH_IMPTRACK,VIS_CH_IMPLOYAL,VIS_CH_IMPCHEM)

/obj/item/clothing/glasses/eyepatch/hud/medical
	name = "MEDpatch"
	desc = "A Medical-type heads-up display that connects directly to the ocular nerve of the user, replacing the need for that useless eyeball."
	icon_state = "medpatch"
	off_state = "hudpatch"
	action_button_name = "Toggle HUD"
	toggleable = 1
	enables_planes = list(VIS_CH_STATUS,VIS_CH_HEALTH)

/obj/item/clothing/glasses/eyepatch/hud/meson
	name = "MESpatch"
	desc = "An optical meson scanner display that connects directly to the ocular nerve of the user, replacing the need for that useless eyeball."
	icon_state = "mespatch"
	off_state = "hudpatch"
	action_button_name = "Toggle Mesons"
	toggleable = 1
	vision_flags = SEE_TURFS
	enables_planes = list(VIS_FULLBRIGHT, VIS_MESONS)

/obj/item/clothing/glasses/hudpatch/meson/New()

	..()
	overlay = global_hud.meson

/obj/item/clothing/glasses/eyepatch/hud/material
	name = "MATpatch"
	desc = "An optical material scanner display that connects directly to the oclar nerve of the user, replacing the need for that useless eyeball."
	icon_state = "matpatch"
	off_state = "hudpatch"
	action_button_name = "Toggle Material scanner"
	toggleable = 1
	vision_flags = SEE_OBJS
	enables_planes = list(VIS_FULLBRIGHT)

/obj/item/clothing/glasses/hudpatch/material/New()

	..()
	overlay = global_hud.material
/////eyepatch Variants End/////

/obj/item/clothing/glasses/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state_slots = list(slot_r_hand_str = "headset", slot_l_hand_str = "headset")
	body_parts_covered = 0

/obj/item/clothing/glasses/material
	name = "optical material scanner"
	desc = "Very confusing glasses."
	icon_state = "material"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	toggleable = 1
	action_button_name = "Toggle Goggles"
	vision_flags = SEE_OBJS
	enables_planes = list(VIS_FULLBRIGHT)

/obj/item/clothing/glasses/material/New()
	..()
	overlay = global_hud.material

/obj/item/clothing/glasses/material/prescription
	name = "prescription optical material scanner"
	prescription = 1

/obj/item/clothing/glasses/regular
	name = "prescription glasses"
	desc = "Made by Nerd. Co."
	icon_state = "glasses"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	prescription = 1
	body_parts_covered = 0

/obj/item/clothing/glasses/regular/scanners
	name = "scanning goggles"
	desc = "A very oddly shaped pair of goggles with bits of wire poking out the sides. A soft humming sound emanates from it."
	icon_state = "uzenwa_sissra_1"

/obj/item/clothing/glasses/regular/hipster
	name = "prescription glasses"
	desc = "Made by Uncool. Co."
	icon_state = "hipster_glasses"

/obj/item/clothing/glasses/threedglasses
	desc = "A long time ago, people used these glasses to makes images from screens threedimensional."
	name = "3D glasses"
	icon_state = "3d"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	body_parts_covered = 0

/obj/item/clothing/glasses/gglasses
	name = "green glasses"
	desc = "Forest green glasses, like the kind you'd wear when hatching a nasty scheme."
	icon_state = "gglasses"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	body_parts_covered = 0

/obj/item/clothing/glasses/sunglasses
	name = "sunglasses"
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Enhanced shielding blocks many flashes."
	icon_state = "sun"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")
	darkness_view = -1
	flash_protection = FLASH_PROTECTION_MODERATE

/obj/item/clothing/glasses/sunglasses/aviator
	name = "aviators"
	desc = "A pair of designer sunglasses."
	icon_state = "aviator"

/obj/item/clothing/glasses/welding
	name = "welding goggles"
	desc = "Protects the eyes from welders, approved by the mad scientist association."
	icon_state = "welding-g"
	item_state_slots = list(slot_r_hand_str = "welding-g", slot_l_hand_str = "welding-g")
	action_button_name = "Flip Welding Goggles"
	matter = list(DEFAULT_WALL_MATERIAL = 1500, "glass" = 1000)
	item_flags = AIRTIGHT
	var/up = 0
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = TINT_HEAVY

/obj/item/clothing/glasses/welding/attack_self()
	toggle()

/obj/item/clothing/glasses/welding/verb/toggle()
	set category = "Object"
	set name = "Adjust welding goggles"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.restrained())
		if(src.up)
			src.up = !src.up
			flags_inv |= HIDEEYES
			body_parts_covered |= EYES
			icon_state = initial(icon_state)
			flash_protection = initial(flash_protection)
			tint = initial(tint)
			to_chat(usr, "You flip \the [src] down to protect your eyes.")
		else
			src.up = !src.up
			flags_inv &= ~HIDEEYES
			body_parts_covered &= ~EYES
			icon_state = "[initial(icon_state)]up"
			flash_protection = FLASH_PROTECTION_NONE
			tint = TINT_NONE
			to_chat(usr, "You push \the [src] up out of your face.")
		update_clothing_icon()
		usr.update_action_buttons()

/obj/item/clothing/glasses/welding/superior
	name = "superior welding goggles"
	desc = "Welding goggles made from more expensive materials, strangely smells like potatoes."
	icon_state = "rwelding-g"
	tint = TINT_MODERATE

/obj/item/clothing/glasses/sunglasses/blindfold
	name = "blindfold"
	desc = "Covers the eyes, preventing sight."
	icon_state = "blindfold"
	item_state_slots = list(slot_r_hand_str = "blindfold", slot_l_hand_str = "blindfold")
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = BLIND

/obj/item/clothing/glasses/sunglasses/blindfold/tape
	name = "length of tape"
	desc = "It's a robust DIY blindfold!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape_cross"
	item_state_slots = list(slot_r_hand_str = null, slot_l_hand_str = null)
	w_class = ITEMSIZE_TINY

/obj/item/clothing/glasses/sunglasses/prescription
	name = "prescription sunglasses"
	prescription = 1

/obj/item/clothing/glasses/sunglasses/big
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Larger than average enhanced shielding blocks many flashes."
	icon_state = "bigsunglasses"

/obj/item/clothing/glasses/sunglasses/goldaviators
	name = "gold aviators"
	desc = "These aviators are painted with a reflective gold sheen. Just looking at them makes you feel richer. Unlike police models, this pair has flash protection."
	icon_state = "gold_aviators"

/obj/item/clothing/glasses/fakesunglasses //Sunglasses without flash immunity
	name = "stylish sunglasses"
	desc = "A pair of designer sunglasses. Doesn't seem like it'll block flashes."
	icon_state = "sun"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")

/obj/item/clothing/glasses/fakesunglasses/aviator
	name = "stylish aviators"
	desc = "A pair of designer sunglasses. Doesn't seem like it'll block flashes."
	icon_state = "aviator"

/obj/item/clothing/glasses/fakesunglasses/ranger
	name = "ranger aviators"

	desc = "A pair of designer Aviators. Good for laying down the law, but bad for blocking flashes."

	icon_state = "sun"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")

/obj/item/clothing/glasses/fakesunglasses/big
	name = "big stylish sunglasses"
	desc = "A pair of designer sunglasses. Doesn't seem like it'll block flashes."
	icon_state = "bigsunglasses"


/obj/item/clothing/glasses/sunglasses/sechud
	name = "\improper HUD sunglasses"
	desc = "Sunglasses with a HUD."
	icon_state = "sunSecHud"
	enables_planes = list(VIS_CH_ID,VIS_CH_WANTED,VIS_CH_IMPTRACK,VIS_CH_IMPLOYAL,VIS_CH_IMPCHEM)

/obj/item/clothing/glasses/sunglasses/sechud/tactical
	name = "tactical HUD"
	desc = "Flash-resistant goggles with inbuilt combat and security information."
	icon_state = "swatgoggles"

/obj/item/clothing/glasses/sunglasses/sechud/aviator
	name = "security HUD aviators"
	desc = "Modified aviator glasses that can be switch between HUD and flash protection modes."
	icon_state = "aviator_sec"
	off_state = "aviator"
	action_button_name = "Toggle Mode"
	var/on = 1
	toggleable = 1
	activation_sound = 'sound/effects/pop.ogg'

/obj/item/clothing/glasses/sunglasses/sechud/aviator/attack_self(mob/user)
	if(toggleable && !user.incapacitated())
		on = !on
		if(on)
			flash_protection = FLASH_PROTECTION_NONE
			enables_planes = away_planes
			away_planes = null
			to_chat(usr, "You switch the [src] to HUD mode.")
		else
			flash_protection = initial(flash_protection)
			away_planes = enables_planes
			enables_planes = null
			to_chat(usr, "You switch \the [src] to flash protection mode.")
		update_icon()
		user << activation_sound
		user.recalculate_vis()
		user.update_inv_glasses()
		user.update_action_buttons()

/obj/item/clothing/glasses/sunglasses/sechud/aviator/update_icon()
	if(on)
		icon_state = initial(icon_state)
	else
		icon_state = off_state

/obj/item/clothing/glasses/sunglasses/sechud/aviator/prescription
	name = "prescription security HUD aviators"
	desc = "Modified aviator glasses that can be switch between HUD and flash protection modes. Comes with bonus prescription lenses."
	prescription = 6

/obj/item/clothing/glasses/sunglasses/medhud
	name = "\improper HUD sunglasses"
	desc = "Sunglasses with a HUD."
	icon_state = "sunMedHud"
	enables_planes = list(VIS_CH_STATUS,VIS_CH_HEALTH)

/obj/item/clothing/glasses/thermal
	name = "optical thermal scanner"
	desc = "Thermals in the shape of glasses."
	icon_state = "thermal"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	origin_tech = list(TECH_MAGNET = 3)
	toggleable = 1
	action_button_name = "Toggle Goggles"
	vision_flags = SEE_MOBS
	enables_planes = list(VIS_FULLBRIGHT)
	flash_protection = FLASH_PROTECTION_REDUCED

	emp_act(severity)
		if(istype(src.loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/M = src.loc
			M << "<font color='red'>The Optical Thermal Scanner overloads and blinds you!</font>"
			if(M.glasses == src)
				M.Blind(3)
				M.eye_blurry = 5
				// Don't cure being nearsighted
				if(!(M.disabilities & NEARSIGHTED))
					M.disabilities |= NEARSIGHTED
					spawn(100)
						M.disabilities &= ~NEARSIGHTED
		..()

/obj/item/clothing/glasses/thermal/New()
	..()
	overlay = global_hud.thermal

/obj/item/clothing/glasses/thermal/syndi	//These are now a traitor item, concealed as mesons.	-Pete
	name = "optical meson scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	item_state_slots = list(slot_r_hand_str = "meson", slot_l_hand_str = "meson")
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 4)

/obj/item/clothing/glasses/thermal/plain
	toggleable = 0
	activation_sound = null
	action_button_name = null

/obj/item/clothing/glasses/thermal/plain/monocle
	name = "thermonocle"
	desc = "A monocle thermal."
	icon_state = "thermoncle"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")
	toggleable = 1
	action_button_name = "Toggle Monocle"
	flags = null //doesn't protect eyes because it's a monocle, duh

	body_parts_covered = 0

/obj/item/clothing/glasses/thermal/plain/eyepatch
	name = "optical thermal eyepatch"
	desc = "An eyepatch with built-in thermal optics"
	icon_state = "eyepatch"
	item_state_slots = list(slot_r_hand_str = "blindfold", slot_l_hand_str = "blindfold")
	body_parts_covered = 0
	toggleable = 1
	action_button_name = "Toggle Eyepatch"

/obj/item/clothing/glasses/thermal/plain/jensen
	name = "optical thermal implants"
	desc = "A set of implantable lenses designed to augment your vision"
	icon_state = "thermalimplants"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")

/obj/item/clothing/glasses/visor
	name = "LED visor"
	desc = "A reinforced glass visor with a multitude of micro-LEDs."
	icon_state = "visor"

/obj/item/clothing/glasses/visor/New()
	..()
	color = "#[get_random_colour()]"
	update_icon()

/obj/item/clothing/glasses/visor/attack_self(mob/user)
	add_fingerprint(user)
	var/new_color = input(usr, "Pick a new color", "Visor Color", color) as color|null

	if(new_color && (new_color != color))
		color = new_color

/obj/item/clothing/glasses/holovisor
	name = "holovisor"
	desc = "A visor that generates a holographic lens. Not very practical, but very cool."
	icon_state = "holovisor-on"
	off_state = "holovisor"
	toggleable = 1
	action_button_name = "Toggle Holovisor"

/obj/item/clothing/glasses/de/binoclard
	name = "binoclard lenses"
	desc = "Stylish round lenses subtly shaded for your protection and criminal discomfort."
	icon_state = "binoclard_lenses"