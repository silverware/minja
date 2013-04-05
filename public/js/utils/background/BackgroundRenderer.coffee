define [
  "text!./vertexShader.vert"
  "text!./fragmentShader.frag"
  "text!./heightmapVertexShader.vert"
  "text!./heightmapFragmentShader.frag"
], (vertexShader, fragmentShader, heightmapVertexShader, heightmapFragmentShader) ->
  VIEW_ANGLE = 20
  NEAR = 1
  FAR = 10000
  CAM_FACTOR = 4

  camera = null
  scene = null
  renderer = null

  heightCamera = null
  heightScene = null
  heightRenderTarget = null

  uniforms = null
  heightUniforms = null

  time = new Date().getSeconds()

  init = ->
    ###--------------------------------------------------------------------------
     init height map
    --------------------------------------------------------------------------###

    heightScene = new THREE.Scene()
    heightCamera = new THREE.Camera()
    heightCamera.position.z = 1
    heightUniforms =
      time: 
        type: "f"
        value: time

    material = new THREE.ShaderMaterial
      uniforms: heightUniforms
      vertexShader: heightmapVertexShader
      fragmentShader: heightmapFragmentShader

    heightScene.add new THREE.Mesh(new THREE.PlaneGeometry(2, 2), material)

    heightRenderTarget = new THREE.WebGLRenderTarget 512, 512,
      minFilter: THREE.LinearFilter
      magFilter: THREE.NearestFilter
      format: THREE.RGBFormat


    ###--------------------------------------------------------------------------
     init main scene
    --------------------------------------------------------------------------###

    scene = new THREE.Scene()
    camera = new THREE.OrthographicCamera -width() / CAM_FACTOR, width() / CAM_FACTOR, height() / CAM_FACTOR, -height() / CAM_FACTOR, NEAR, FAR

    camera.position.y = 60
    camera.position.z = 200
    camera.lookAt new THREE.Vector3 0, 0, 0
    scene.add camera

    renderer = new THREE.WebGLRenderer
      antialias: false
    renderer.setSize width(), height()
    canvas = $(renderer.domElement).hide().fadeIn(6000)
    $("body").append canvas

    uniforms =
      heightmap: 
        type: 't'
        value: heightRenderTarget

    shaderMaterial = new THREE.ShaderMaterial
      uniforms: uniforms
      vertexShader: vertexShader
      fragmentShader: fragmentShader
    
    geometry = new THREE.PlaneGeometry 1000, 300, 100, 100
    plane = new THREE.Mesh geometry, shaderMaterial
    plane.rotation.x = -Math.PI / 2
    scene.add plane

    window.addEventListener 'resize', onWindowResize, false
    animate()

  onWindowResize = ->
    renderer.setSize width(), height()
    camera.left = -width() / CAM_FACTOR
    camera.right = width() / CAM_FACTOR
    camera.top = height() / CAM_FACTOR
    camera.bottom = -height() / CAM_FACTOR
    camera.updateProjectionMatrix()

  animate = ->
    requestAnimationFrame animate
    render()
  
  width = ->
    $(window).width()

  height = ->
    window.innerHeight

  render = ->
    heightUniforms.time.value = time
    time += 0.002
    renderer.render heightScene, heightCamera, heightRenderTarget, true
    renderer.render scene, camera

  exports =
    init: init